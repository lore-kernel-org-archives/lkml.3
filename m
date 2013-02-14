Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab3BNOko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab3BNOkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:40:42 -0500
Date: Thu, 14 Feb 2013 09:40:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130214144033.GA13047@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
 <CALLzPKbdrvsPuH9t19rvQqGZ=0+abPuWPNke4FLsadj0ORieJg@mail.gmail.com>
 <1360791923.3524.466.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360791923.3524.466.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 04:45:23PM -0500, Mimi Zohar wrote:

[..]
> Option 3: appraise_type:= [imasig] | [imahash] | [optional]
> 
> Dmitry is recommending this syntax, as IMA_DIGSIG will be set in the
> iint flags.

I like option 3. If there is a use case down the line where definition
of optional needs to be refined in such a way that we want to force
signature or hash then we can extend appraise_type to also include
following.

Option 3: appraise_type:= [imasig] | [imahash] | [optional] |
				[imasig_optional] | [imahash_optional]

> 
> 
> Any of these options should work.
> 
> > If it would happen that it contains signature, then IMA_DIGSIG flag
> > would be set,
> > and process could get needed capability as Vivek wants.
> 
> With the 'optional' condition, both unsigned and validly signed files
> will succeed.  One way of making this information accessible to an LSM,
> would be to define a new integrity capability and set it here.  The new
> integrity capability would indicate the file was validly signed. 

Thinking loud.

The problem with integrity capability is that it goes only so far. If
we provide capability in exec() path, then that capability means much
more in the sense, we know file is locked to run from memory. An integrity
capability just means file is validly signed.

So exec() code might have to do another capability on top which will
also ensure that file is executable is locked in memory and signature
verification is done after loading in memory so that it is not open
to writing to disk block attacks.

And based on this capability we probably need to deny write access to file
till file is open for exec() (I noticed that after load, we seem to be
allowing access to write access).

Thanks
Vivek
