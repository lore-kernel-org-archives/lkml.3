Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab3BNPpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:45:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35540 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3BNPpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:45:39 -0500
Message-ID: <1360856159.3524.619.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 10:35:59 -0500
In-Reply-To: <20130214152339.GB16671@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
	 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
	 <20130213165922.GD6750@redhat.com>
	 <1360846636.3524.589.camel@falcor1.watson.ibm.com>
	 <20130214152339.GB16671@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 13021415-4834-0000-0000-000003AEB121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 10:23 -0500, Vivek Goyal wrote:
> On Thu, Feb 14, 2013 at 07:57:16AM -0500, Mimi Zohar wrote:
> 
> [..]
> > > Ok, I will cleanup the code to do above. Just wanted to clear up one
> > > point. 
> > > 
> > > Above option will not have any effect on evm behavior? This only impacts
> > > IMA appraisal behavior. For example, if security.ima is not present it
> > > is fine and file access is allowed. But if EVM is enabled and initialized
> > > and EVM does not find security.evm label (INTEGRITY_NOLABEL) or returns
> > > INTEGRITY_NOXATTRS, file access should still be denied?
> > 
> > Can't happen.  evm_verifyxattr() is called from
> > ima_appraise_measurement(), only if 'security.ima' exists.
> 
> Actually what I meant is following.
> 
> Currently in process_measurement(), I will allow access if
> ima_appraise_measurement() returns INTEGRITY_NOLABEL.

I think you're making this more complicated than it needs to be.  Allow
the execution unless the file failed signature verification.  The
additional capability is given only if the signature verification
succeeds.

thanks,

Mimi

