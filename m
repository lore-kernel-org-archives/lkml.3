Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab3DJU31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:29:27 -0400
Received: from mout.gmx.net ([212.227.15.19]:59899 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762837Ab3DJU30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:29:26 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18fCFl3HtYf5JmHBxclItWu/TnfT+E76eI+1uoVOA
	EduNOTzdqon/If
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net,
        Matthias Leblanc <mathias.leblanc@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        "Jean-Luc Blanc" <jean-luc.blanc@st.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Date: Wed, 10 Apr 2013 22:32:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.4; KDE/4.9.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mathias leblanc <mathias.lebanc@st.com>
References: <1365518562-3678-1-git-send-email-mathias.leblanc@st.com>
In-Reply-To: <1365518562-3678-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304102232.06682.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

Am Dienstag, 9. April 2013, 16:42:42 schrieb Matthias Leblanc:
> From: Mathias leblanc <mathias.lebanc@st.com>
> 
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.
> 
> If you have a TPM security chip from STMicroelectronics working with
> an SPI, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64 and beagleboard REV B & XM REV C
> 
> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>


fails to compile for me.

Steps to reproduce (on x86_64):
make defconfig
 git reset --hard  tpmdd/tpmdd-03-04-13
 make defconfig
 git am /tmp/\[tpmdd-devel\]\ \[PATCH\ 1_1\]\ TPM_STMicroelectronics\ st33\ driver\ SPI.mbox 
 make menuconfig -> enable spi, gpio, and the TPM
 make 


LANG=C make
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
make[3]: `arch/x86/realmode/rm/realmode.bin' is up to date.
  LD [M]  drivers/char/tpm/tpm_bios.o
  CC [M]  drivers/char/tpm/tpm_spi_stm_st33.o
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'write8_reg':
drivers/char/tpm/tpm_spi_stm_st33.c:115:33: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:118:27: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:121:28: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:149:32: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'read8_reg':
drivers/char/tpm/tpm_spi_stm_st33.c:188:33: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:191:27: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:195:28: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function '_wait_for_interrupt_serirq_timeout':
drivers/char/tpm/tpm_spi_stm_st33.c:323:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:325:35: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:326:32: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_ioserirq_handler':
drivers/char/tpm/tpm_spi_stm_st33.c:605:21: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'evaluate_latency':
drivers/char/tpm/tpm_spi_stm_st33.c:802:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_st33_spi_probe':
drivers/char/tpm/tpm_spi_stm_st33.c:864:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:867:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:871:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:874:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:889:35: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:892:31: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:895:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:896:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:904:33: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:909:35: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:915:46: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:921:4: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:959:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:964:36: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:967:26: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:970:26: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:973:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:974:22: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:975:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:978:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:979:22: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:980:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:983:15: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_st33_spi_remove':
drivers/char/tpm/tpm_spi_stm_st33.c:1004:22: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1007:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1009:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1010:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1011:13: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1013:16: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1014:19: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1015:13: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_st33_spi_pm_suspend':
drivers/char/tpm/tpm_spi_stm_st33.c:1041:27: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1044:33: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c: In function 'tpm_st33_spi_pm_resume':
drivers/char/tpm/tpm_spi_stm_st33.c:1064:27: error: dereferencing pointer to incomplete type
drivers/char/tpm/tpm_spi_stm_st33.c:1071:33: error: dereferencing pointer to incomplete type
make[3]: *** [drivers/char/tpm/tpm_spi_stm_st33.o] Error 1
make[2]: *** [drivers/char/tpm] Error 2
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2


This is caused by your double inclusion guard in 
include/linux/spi/tpm_spi_stm_st33.h

#ifndef __STM_ST33_TPM_SPI_H__
#define __STM_ST33_TPM_SPI_H__

#include <linux/spi/spi.h>

#define TPM_ST33_SPI            "st33zp24_spi"

#ifndef __STM_ST33_TPM_SPI_H__  <------- the define was just a few lines before
struct st33zp24_platform_data {



Regards,
Peter




