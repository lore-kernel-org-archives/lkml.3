Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaIXR2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:28:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:35019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaIXR2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604770266"
Date: Wed, 24 Sep 2014 20:28:01 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        stefanb@linux.vnet.ibm.com
Subject: Re: [PATCH v1 00/12] tpm: TPM2 support
Message-ID: <20140924172801.GA5060@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:05:50PM +0300, Jarkko Sakkinen wrote:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces.

Known issues so far:

- le32/le64_to_cpu()'s and one cpu_to_le32 missing from tpm_crb.c
  assuming that CRB driver would be used in big-endian architecture.
- I still have troubles having FIFO testing environment so it would
  not be a big surprise if it had broke for some reason (help with
  testing and/or bug fixes for FIFO would be highly appreciated).

Notes about the implementation:

- Reworked the code base to the direction that Jason Gunthorpe suggested.
- Moved to use devres in tpm_crb as Jason suggested.
- Did some groundwork for implementing Stefan Bergers suggestions to
  tpm_crb.

I hope that it is now more in right direction than in my preview.

I'll push fixes on top of tpm2-v1 branch [1] and do not rebase it anymore
and therefore it is a good testing branch.

When things look good enough I'll create tpm2-v2 branch and prepare and
send a new patch set.

[1] https://github.com/jsakkine/linux-tpm2/

/Jarko

> Jarkko Sakkinen (8):
>   tpm: prepare TPM driver for adding TPM2 support
>   tpm: TPM2 support for tpm_pcr_read()
>   tpm: TPM2 support for tpm_do_selftest()
>   tpm: added tpm2_get_tpm_pt()
>   tpm: TPM2 support for tpm_pcr_extend()
>   tpm: TPM2 support for tpm_get_random().
>   tpm: Driver for TPM 2.0 CRB Interface
>   tpm: TPM2 sysfs attributes
> 
> Will Arthur (4):
>   tpm: TPM2 support for tpm_calc_ordinal_durations()
>   tpm: TPM2 support for tpm_startup()
>   tpm: TPM2 support for tpm_gen_interrupt().
>   tpm: TPM 2.0 FIFO Interface
> 
>  drivers/char/tpm/Kconfig         |   9 +
>  drivers/char/tpm/Makefile        |   3 +-
>  drivers/char/tpm/tpm-chip.c      | 175 ++++++++++++++++
>  drivers/char/tpm/tpm-interface.c | 160 +++++----------
>  drivers/char/tpm/tpm.h           |  84 ++++++++
>  drivers/char/tpm/tpm2-commands.c | 422 +++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm2-sysfs.c    | 242 ++++++++++++++++++++++
>  drivers/char/tpm/tpm2.h          | 108 ++++++++++
>  drivers/char/tpm/tpm_crb.c       | 332 ++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_tis.c       |  53 ++++-
>  10 files changed, 1463 insertions(+), 125 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm-chip.c
>  create mode 100644 drivers/char/tpm/tpm2-commands.c
>  create mode 100644 drivers/char/tpm/tpm2-sysfs.c
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm_crb.c
> 
> -- 
> 2.1.0
> 
