Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab3BNM51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:57:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44912 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758994Ab3BNM5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:57:25 -0500
Message-ID: <1360846636.3524.589.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 07:57:16 -0500
In-Reply-To: <20130213165922.GD6750@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
	 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
	 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
	 <20130213165922.GD6750@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021412-9360-0000-0000-00001090E419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 11:59 -0500, Vivek Goyal wrote:
> On Wed, Feb 13, 2013 at 08:44:04AM -0500, Mimi Zohar wrote:
> 
> [..]
> > > I see it is more logical if it is "appraise_type=optional",
> > > which means that we might have no xattr value, hash or signature.
> > > It if happens to be a signature, then IMA_DIGSIG flag will be set.
> > 
> > Right, 'appraise_type=' could have been defined either as a comma
> > separated list of options (eg. appraise_type=imassig,optional) or, as
> > Vivek implemented, a new option.  Eventually, we will need to extend
> > 'appraise_type=' (eg. required algorithm), but for now I don't have a
> > problem with the new option.
> 
> Ok, I will cleanup the code to do above. Just wanted to clear up one
> point. 
> 
> Above option will not have any effect on evm behavior? This only impacts
> IMA appraisal behavior. For example, if security.ima is not present it
> is fine and file access is allowed. But if EVM is enabled and initialized
> and EVM does not find security.evm label (INTEGRITY_NOLABEL) or returns
> INTEGRITY_NOXATTRS, file access should still be denied?

Can't happen.  evm_verifyxattr() is called from
ima_appraise_measurement(), only if 'security.ima' exists.

> BTW, what's the difference between INTEGRITY_NOLABEL and
> INTEGRITY_NOXATTRS (as returned by evm_verifyxattr()).

INTEGRITY_NOLABEL indicates the requested xattr doesn't exist, while
INTEGRITY_NOXATTRS implies no EVM protected xattrs exist.  The latter
normally occurs when a file is first created.

Mimi

