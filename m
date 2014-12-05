Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaLENL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:11:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:7381 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaLENL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:11:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="633206917"
Date: Fri, 5 Dec 2014 15:10:25 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v9 7/8] tpm: TPM 2.0 CRB Interface
Message-ID: <20141205131025.GE6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412042119.21493.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412042119.21493.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll fix these (an run sparse).

/Jarkko

On Thu, Dec 04, 2014 at 09:19:21PM +0100, Peter Hüwe wrote:
> Am Donnerstag, 4. Dezember 2014, 06:55:17 schrieb Jarkko Sakkinen:
> > tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Interface
> > as defined in PC Client Platform TPM Profile (PTP) Specification.
> > 
> > Only polling and single locality is supported as these are the limitations
> > of the available hardware, Platform Trust Techonlogy (PTT) in Haswell
> > CPUs.
> > 
> > The driver always applies CRB with ACPI start because PTT reports using
> > only ACPI start as start method but as a result of my testing it requires
> > also CRB start.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> :(
> 
>  make -C /data/data-old/linux-2.6/ M=$(pwd) modules C=1 CHECK=sparse
> make: Entering directory '/data/data-old/linux-2.6'
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:99:5: warning: symbol 'crb_suspend' was not declared. Should it be static?
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:121:14:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:137:13:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:173:19:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:177:34:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63: warning: incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:187:63:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56: warning: incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:199:56:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27: warning: incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:207:27:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:277:22: warning: cast removes address space of expression
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33: warning: incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    expected void const volatile [noderef] <asn:2>*src
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:284:33:    got unsigned long long *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:287:56:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19: warning: incorrect type in assignment (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    expected unsigned char [usertype] *cmd
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:286:19:    got void [noderef] <asn:2>*
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33: warning: incorrect type in argument 2 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    expected void const volatile [noderef] <asn:2>*src
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:293:33:    got unsigned long long *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56: warning: incorrect type in argument 1 (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    expected void [noderef] <asn:2>*<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:296:56:    got unsigned int *<noident>
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19: warning: incorrect type in assignment (different address spaces)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    expected unsigned char [usertype] *rsp
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:295:19:    got void [noderef] <asn:2>*
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.c:325:5: warning: symbol 'crb_acpi_remove' was not declared. Should it be static?
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_crb.o
> 
> :(
> Peter
