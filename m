Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643Ab3BNPXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab3BNPXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:23:42 -0500
Date: Thu, 14 Feb 2013 10:23:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130214152339.GB16671@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
 <20130213165922.GD6750@redhat.com>
 <1360846636.3524.589.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360846636.3524.589.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:57:16AM -0500, Mimi Zohar wrote:

[..]
> > Ok, I will cleanup the code to do above. Just wanted to clear up one
> > point. 
> > 
> > Above option will not have any effect on evm behavior? This only impacts
> > IMA appraisal behavior. For example, if security.ima is not present it
> > is fine and file access is allowed. But if EVM is enabled and initialized
> > and EVM does not find security.evm label (INTEGRITY_NOLABEL) or returns
> > INTEGRITY_NOXATTRS, file access should still be denied?
> 
> Can't happen.  evm_verifyxattr() is called from
> ima_appraise_measurement(), only if 'security.ima' exists.

Actually what I meant is following.

Currently in process_measurement(), I will allow access if
ima_appraise_measurement() returns INTEGRITY_NOLABEL.

Now this could mean 2 things.

- security.ima was not present.
- security.ima was there but security.evm was not present.

With appraise_type=optional, I think we would want to allow access in
first case but not the second one. IOW, appraise_type= affects behavior
of IMA and not EVM.

That means we need to introduce new codes.

INTEGRITY_IMA_NOLABEL and INTEGRITY_EVM_NOLABEL to differentiate between
above two cases?

Thanks
Vivek
