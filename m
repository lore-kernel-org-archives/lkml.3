Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaCFIyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:54:05 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10859 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaCFIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:54:00 -0500
X-IronPort-AV: E=Sophos;i="4.97,598,1389772800"; 
   d="scan'208";a="18029336"
Message-ID: <531837A6.8090406@broadcom.com>
Date: Thu, 6 Mar 2014 09:53:58 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Hante Meuleman" <meuleman@broadcom.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
References: <20140306134332.0c3f12ec6849d1b2ccefda6e@canb.auug.org.au>
In-Reply-To: <20140306134332.0c3f12ec6849d1b2ccefda6e@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 03:43 AM, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless-next tree, today's linux-next build
> (arm multi_v7_defconfig) failed like this:
> 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function
> 'brcmf_sdio_intr_rstatus': 
> drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:2464:3: error:
> implicit declaration of function 'atomic_set_mask'
> [-Werror=implicit-function-declaration]
> 
> Caused by commit c98db0bec72a ("brcmfmac: Use atomic functions for 
> intstatus update").  Arm does not seem to provide
> atomic_set_mask()?
> 
> I reverted that commit for today.

That is fine. The kbuild robot also found issue with this function on
other archs. I must say I am surprised as this code fragment in
asm-generic/atomic.h suggests it is needed for SMP to work (?):

 20 #ifdef CONFIG_SMP
 21 /* Force people to define core atomics */
 22 # if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
 23      !defined(atomic_clear_mask) || !defined(atomic_set_mask)
 24 #  error "SMP requires a little arch-specific magic"
 25 # endif
 26 #endif

Maybe this requirement is no longer valid. Anyway. I will sent revert
patch and replacement to John.

Thanks,
Arend
