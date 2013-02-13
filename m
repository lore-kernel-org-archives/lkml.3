Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3BMQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:59:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759808Ab3BMQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:59:31 -0500
Date: Wed, 13 Feb 2013 11:59:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130213165922.GD6750@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360763044.3524.367.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 08:44:04AM -0500, Mimi Zohar wrote:

[..]
> > I see it is more logical if it is "appraise_type=optional",
> > which means that we might have no xattr value, hash or signature.
> > It if happens to be a signature, then IMA_DIGSIG flag will be set.
> 
> Right, 'appraise_type=' could have been defined either as a comma
> separated list of options (eg. appraise_type=imassig,optional) or, as
> Vivek implemented, a new option.  Eventually, we will need to extend
> 'appraise_type=' (eg. required algorithm), but for now I don't have a
> problem with the new option.

Ok, I will cleanup the code to do above. Just wanted to clear up one
point. 

Above option will not have any effect on evm behavior? This only impacts
IMA appraisal behavior. For example, if security.ima is not present it
is fine and file access is allowed. But if EVM is enabled and initialized
and EVM does not find security.evm label (INTEGRITY_NOLABEL) or returns
INTEGRITY_NOXATTRS, file access should still be denied?

BTW, what's the difference between INTEGRITY_NOLABEL and
INTEGRITY_NOXATTRS (as returned by evm_verifyxattr()).

If yes, we probbaly need to differentiate between IMA/EVM nolabel. Say,
INTEGRITY_IMA_NOLABEL and INTEGRITY_EVM_NOLABEL. appraise_type=optional
should allow file access if rc = INTEGRITY_IMA_NOLABEL but deny it
when rc = INTEGRITY_EVM_NOLABEL?

Thanks
Vivek
