Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaKAJdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 05:33:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:54310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaKAJdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 05:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="600185613"
Date: Sat, 1 Nov 2014 11:33:43 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 0/7] TPM 2.0 support
Message-ID: <20141101093343.GA28272@intel.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I pushed couples of fixed in addition to these changes to:

https://github.com/jsakkine/linux-tpm2/tree/tpm2-v5

There was problem running self-test because the FIFO module that I have
seems to give me TPM2_RC_TESTING when I try to start the self-test.

Additionally. I was able to test force parameter for tpm_tis. Resources
are cleaned up properly at least for TPM2 devices.

/Jarkko

On Sat, Nov 01, 2014 at 11:01:28AM +0200, Jarkko Sakkinen wrote:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces.
> 
> Major changes since v1:
> 
> - Improved struct tpm_chip life-cycle by taking advantage of devres
>   API.
> - Refined sysfs attributes as simple key-values thereby not repeating
>   mistakes in TPM1 sysfs attributes.
> - Documented functions in tpm-chip.c and tpm2-cmd.c.
> - Documented sysfs attributes.
> 
> Major changes since v2:
> 
> - Lots of fixes in calling order in device drivers (thanks to Jason
>   Gunthorpe for pointing these out!).
> - Attach sysfs attributes to the misc device because it represents
>   TPM device to the user space.
> 
> Major changes since v3:
> 
> - Disable sysfs attibutes for TPM 2.0 for until we can sort out the 
>   best approach for them.
> - Fixed all the style issues found with checkpatch.pl.
> 
> Major changes since v4:
> 
> - missing EXPORT_SYMBOL_GPL()
> - own class for TPM devices used for TPM 2.0 devices and onwards.
> 
> Jarkko Sakkinen (6):
>   tpm: merge duplicate transmit_cmd() functions
>   tpm: two-phase chip management functions
>   tpm: fix multiple race conditions in tpm_ppi.c
>   tpm: TPM 2.0 baseline support
>   tpm: TPM 2.0 CRB Interface
>   tpm: create TPM 2.0 devices using own device class
> 
> Will Arthur (1):
>   tpm: TPM 2.0 FIFO Interface
> 
>  drivers/char/tpm/Kconfig            |   9 +
>  drivers/char/tpm/Makefile           |   3 +-
>  drivers/char/tpm/tpm-chip.c         | 209 +++++++++++++
>  drivers/char/tpm/tpm-dev.c          |  77 ++++-
>  drivers/char/tpm/tpm-interface.c    | 256 +++++-----------
>  drivers/char/tpm/tpm-sysfs.c        |  29 +-
>  drivers/char/tpm/tpm.h              | 113 ++++++-
>  drivers/char/tpm/tpm2-cmd.c         | 566 ++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_atmel.c        |  26 +-
>  drivers/char/tpm/tpm_crb.c          | 334 +++++++++++++++++++++
>  drivers/char/tpm/tpm_i2c_atmel.c    |  49 ++--
>  drivers/char/tpm/tpm_i2c_infineon.c |  43 +--
>  drivers/char/tpm/tpm_i2c_nuvoton.c  |  66 ++---
>  drivers/char/tpm/tpm_i2c_stm_st33.c |  44 ++-
>  drivers/char/tpm/tpm_ibmvtpm.c      |  17 +-
>  drivers/char/tpm/tpm_infineon.c     |  51 ++--
>  drivers/char/tpm/tpm_nsc.c          |  34 ++-
>  drivers/char/tpm/tpm_ppi.c          | 136 +++++----
>  drivers/char/tpm/tpm_tis.c          | 177 ++++++-----
>  drivers/char/tpm/xen-tpmfront.c     |  14 +-
>  20 files changed, 1711 insertions(+), 542 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-chip.c
>  create mode 100644 drivers/char/tpm/tpm2-cmd.c
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> -- 
> 2.1.0
> 
