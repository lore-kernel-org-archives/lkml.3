Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaLDUoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:44:30 -0500
Received: from mout.gmx.net ([212.227.17.22]:51697 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaLDUo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:44:28 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 4/8] tpm: rename chip->dev to chip->pdev
Date: Thu, 4 Dec 2014 21:49:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-5-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417672518-4530-5-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201412042149.41813.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:v2VB3YBaOgrNAlpeW16RelyvTlPBjsw8BdzZLdXsNcWT/hTt5Bq
 AIFIOcfCgpbkUFhMm5bx3HXbUNJSiFKJtbt0TLu4idO3RsxJICP+u9GSfjmOfM0od7X5OJB
 Tp+ZpjN55TT/6JMFbr+Cstaa8SiBYIJ9fc+1oRRSPUsEK17v7eWQybSfQPiJdtkU1fMlH3P
 USZLnaEwcTXopEb4qIvJA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:14 schrieb Jarkko Sakkinen:
> Rename chip->dev to chip->pdev to make it explicit that this not the
> character device but actually represents the platform device.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-chip.c         |  4 ++--
>  drivers/char/tpm/tpm-dev.c          | 10 +++++-----
>  drivers/char/tpm/tpm-interface.c    | 29 +++++++++++++++--------------
>  drivers/char/tpm/tpm-sysfs.c        |  6 +++---
>  drivers/char/tpm/tpm.h              |  4 ++--
>  drivers/char/tpm/tpm_atmel.c        | 14 +++++++-------
>  drivers/char/tpm/tpm_i2c_atmel.c    | 16 ++++++++--------
>  drivers/char/tpm/tpm_i2c_infineon.c |  6 +++---
>  drivers/char/tpm/tpm_i2c_nuvoton.c  | 22 +++++++++++-----------
>  drivers/char/tpm/tpm_i2c_stm_st33.c | 14 +++++++-------
>  drivers/char/tpm/tpm_infineon.c     | 22 +++++++++++-----------
>  drivers/char/tpm/tpm_nsc.c          | 20 ++++++++++----------
>  drivers/char/tpm/tpm_ppi.c          |  4 ++--
>  drivers/char/tpm/tpm_tis.c          | 14 +++++++-------
>  14 files changed, 93 insertions(+), 92 deletions(-)
> 
:(

With CONFIG_OF set I get a compile error.

drivers/char/tpm/tpm_i2c_stm_st33.c: In Funktion »tpm_stm_i2c_of_request_resources«:
drivers/char/tpm/tpm_i2c_stm_st33.c:649:3: Fehler: Inkompatibler Typ für Argument 1 von »dev_err«
In file included from include/linux/pci.h:30:0,
                 from drivers/char/tpm/tpm_i2c_stm_st33.c:32:
include/linux/device.h:1044:5: Anmerkung: »const struct device *« erwartet, aber Argument hat Typ »struct device«
drivers/char/tpm/tpm_i2c_stm_st33.c:662:3: Fehler: Inkompatibler Typ für Argument 1 von »dev_err«
In file included from include/linux/pci.h:30:0,
                 from drivers/char/tpm/tpm_i2c_stm_st33.c:32:
include/linux/device.h:1044:5: Anmerkung: »const struct device *« erwartet, aber Argument hat Typ »struct device«
scripts/Makefile.build:263: recipe for target 'drivers/char/tpm/tpm_i2c_stm_st33.o' failed
make[3]: *** [drivers/char/tpm/tpm_i2c_stm_st33.o] Error 1
scripts/Makefile.build:404: recipe for target 'drivers/char/tpm' failed
make[2]: *** [drivers/char/tpm] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/char' failed
make[1]: *** [drivers/char] Error 2
Makefile:929: recipe for target 'drivers' failed
make: *** [drivers] Error 2


Sorry,
Peter
