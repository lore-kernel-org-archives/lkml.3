Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3LTUeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:34:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LTUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:34:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 2/7] ARM: msm: Add support for APQ8074 Dragonboard
Date: Fri, 20 Dec 2013 21:34:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1387566560-23948-1-git-send-email-davidb@codeaurora.org> <1387566560-23948-3-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1387566560-23948-3-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312202134.42027.arnd@arndb.de>
X-Provags-ID: V02:K0:6D7VC+ihgw+LcBOhZ89YrTdw3986Mh8jpS9pzD2gEYK
 CwNdlw+UECdOPI11OzVTne3dL6yJ2WiulcKJJNEzaVJdcmIrmu
 6yNwXh/2ELdAouby+x7jhOJosNGk6w1ljjTgQMV7RELDfK5ZxB
 z0OkzLvvAZy1lG1BFaTMBrf4L/Xp/mE0JBO66hbfWXDmzt6Kxp
 b1OoZcIRcFHAnLoAwRczXAyYFRA9Xn37gk+2vgwmoM3IDEDZEF
 F2l6i/uvJNQ+Dqy8t0+s8PxucqAB9ottzw5v1jU5EWrkPYwyLi
 YI6S5zcEHzfVRU4hHooMj6t99Ajmbc5XKV4m0HMHHYSG3MvbjC
 8yKWJb3DMeEqDNHmqHv0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013, David Brown wrote:
> diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
> index 16e6183..1f11d93 100644
> --- a/arch/arm/mach-msm/board-dt.c
> +++ b/arch/arm/mach-msm/board-dt.c
> @@ -26,7 +26,16 @@ static const char * const msm_dt_match[] __initconst = {
>         NULL
>  };
>  
> +static const char * const apq8074_dt_match[] __initconst = {
> +       "qcom,apq8074-dragonboard",
> +       NULL
> +};
> +
>  DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
>         .smp = smp_ops(msm_smp_ops),
>         .dt_compat = msm_dt_match,
>  MACHINE_END
> +
> +DT_MACHINE_START(APQ_DT, "Qualcomm MSM (Flattened Device Tree)")
> +       .dt_compat = apq8074_dt_match,
> +MACHINE_END
> -- 

Why can't you reuse the MSM_DT definition and just add the dragonboard
to the list of compatible machines? The presence of the smp_ops pointer
should not matter if you don't support SMP.

	Arnd
