Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab3BNRCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:02:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44970 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab3BNRCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:02:44 -0500
Message-ID: <1360856928.3524.626.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 10:48:48 -0500
In-Reply-To: <20130214144033.GA13047@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
	 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
	 <CALLzPKbdrvsPuH9t19rvQqGZ=0+abPuWPNke4FLsadj0ORieJg@mail.gmail.com>
	 <1360791923.3524.466.camel@falcor1.watson.ibm.com>
	 <20130214144033.GA13047@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021416-8974-0000-0000-000015238441
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 09:40 -0500, Vivek Goyal wrote:
> On Wed, Feb 13, 2013 at 04:45:23PM -0500, Mimi Zohar wrote:
> 
[..]

> > > If it would happen that it contains signature, then IMA_DIGSIG flag
> > > would be set,
> > > and process could get needed capability as Vivek wants.
> > 
> > With the 'optional' condition, both unsigned and validly signed files
> > will succeed.  One way of making this information accessible to an LSM,
> > would be to define a new integrity capability and set it here.  The new
> > integrity capability would indicate the file was validly signed. 
> 
> Thinking loud.
> 
> The problem with integrity capability is that it goes only so far. If
> we provide capability in exec() path, then that capability means much
> more in the sense, we know file is locked to run from memory. An integrity
> capability just means file is validly signed.

> So exec() code might have to do another capability on top which will
> also ensure that file is executable is locked in memory and signature
> verification is done after loading in memory so that it is not open
> to writing to disk block attacks.
> 
> And based on this capability we probably need to deny write access to file
> till file is open for exec() (I noticed that after load, we seem to be
> allowing access to write access).

I think we're back to my original comment that the bprm_check hook might
need to be moved or an additional hook added, as the existing bprm_check
hook is located before the file is locked from modification.  :)

thanks,

Mimi



