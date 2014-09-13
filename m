Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaIMXBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 19:01:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:38601 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaIMXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 19:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,519,1406617200"; 
   d="scan'208";a="572790341"
Date: Sun, 14 Sep 2014 01:21:49 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
Subject: Re: [PATCH] tpm: merge duplicate transmit_cmd() functions
Message-ID: <20140913222149.GA18787@intel.com>
References: <1410629733-10105-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201409132313.53402.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409132313.53402.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Sep 13, 2014 at 11:13:53PM +0200, Peter Hüwe wrote:
> Hi
> 
> 
> Am Samstag, 13. September 2014, 19:35:33 schrieb Jarkko Sakkinen:
> > Replaced transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c
> > with a single tpm_transmit_cmd() that can be used in both files.
> > 
> > This patch is preliminary clean up work for the TPM2 support. This
> > function is needed for implementing TPM2 versions of the in-kernel
> > TPM utility functions.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> why the renaming?

Because all the other non-static functions have tpm_ prefix.

> > 
> >  ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> >  		     size_t bufsiz);
> Can this be removed then?

Yes, it could be declared as a static function in tpm-interface.c and
removed from tpm.h. I'll make this change and send a revised patch.

> > +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
> > +			 int len, const char *desc);
> >  extern int tpm_get_timeouts(struct tpm_chip *);
> >  extern void tpm_gen_interrupt(struct tpm_chip *);
> >  extern int tpm_do_selftest(struct tpm_chip *);
> 
> 
> 
> Peter

/Jarkko
