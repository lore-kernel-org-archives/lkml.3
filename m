Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3AYSQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:16:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64501 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3AYSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:16:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,540,1355126400"; 
   d="scan'208";a="22439066"
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@list.infradead.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <c_dwalke@quicinc.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 03/19] ARM: msm: proc_comm_boot_wait should not be __init
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359123276-15833-4-git-send-email-arnd@arndb.de>
Date: Fri, 25 Jan 2013 10:16:31 -0800
In-Reply-To: <1359123276-15833-4-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 25 Jan 2013 14:14:20 +0000")
Message-ID: <8yak3r15ds0.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> msm_smd_probe is a driver probe function and may get
> called after the __init time, so it must not call
> any __init function, as the link-time warning reports.
> Take away the __init annotation on proc_comm_boot_wait
> to fix this.
>
> Without this patch, building msm_defconfig results in:
>
> WARNING: vmlinux.o(.text+0xb048): Section mismatch in reference from the function msm_smd_probe() to the function .init.text:proc_comm_boot_wait()
> The function msm_smd_probe() references
> the function __init proc_comm_boot_wait().
> This is often because msm_smd_probe lacks a __init
> annotation or the annotation of proc_comm_boot_wait is wrong.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Daniel Walker <c_dwalke@quicinc.com>
> Cc: linux-arm-msm@vger.kernel.org
> ---
>  arch/arm/mach-msm/proc_comm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Arnd, you're welcome to pull this into your tree:
Acked-by: David Brown <davidb@codeaurora.org>

I don't forsee any conflicts with upcoming patches.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
