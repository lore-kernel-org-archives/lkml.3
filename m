Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab3LIQJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:09:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29069 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3LIQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:09:32 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-b4-52a5eb395c8c
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, wsa@the-dreams.de
Cc: linux-i2c@vger.kernel.org, sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com
Subject: Re: [PATCH v4] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Mon, 09 Dec 2013 17:09:19 +0100
Message-id: <1750845.YHGrteBMYZ@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1385439767-18586-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
 <1385439767-18586-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7qWr5cGGTQ8NbSYtO4Ak8XUh0/Y
	LO4+P8xo8fKQpsXZZQfZLF6d2chm0fH3C6PF5V1z2CxmnN/HZPFtyzZGi5UnZjE7cHvMbrjI
	4vF31Qtmj02rOtk8+rasYvT4+VLH4+SpJywenzfJBbBHcdmkpOZklqUW6dslcGW0fAwo+MpZ
	8fnXAtYGxh6OLkZODgkBE4lTp9cyQthiEhfurWfrYuTiEBJYyijx+N0Xdgini0li3eNnLCBV
	bAJqEp8bHgFVcXCICLhLrL4pClLDLPCYUWLBxkVgNcICERKn214zg9gsAqoSLyf0gdm8ApoS
	Rw8sZgWx+QXUJd5te8oEYosKuEm82LeFHcTmBLI3PtnOBLG4kVFizfeHLBDNghI/Jt8Ds5kF
	5CX27Z/KCmFrSazfeZxpAqPgLCRls5CUzUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+
	7iZGSNx82cG4+JjVIUYBDkYlHt4VrEuDhFgTy4orcw8xSnAwK4nwiu0CCvGmJFZWpRblxxeV
	5qQWH2Jk4uCUamD0vMpxXDXlAddd6eb3wq/aPGb+WVOS5Grcdkh3wlSernCl++Znztu8ffOF
	cSNb5hkRmwlXvqz8yc13cUW99N3Fh7iC23mnuK/uuSF07iPnzB2umiynNJbe+2I4h/Ww3rZ1
	11+0KRnoL61I9OgyNJrz4dOBCmerjYt3fRO//CnqmnKwlvvvrbH/lFiKMxINtZiLihMB6pwx
	PnkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 26 of November 2013 09:52:46 Naveen Krishna Chatradhi wrote:
> For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
> on a fixed 66 MHz peripheral clock, and therefore is completely
> independent of the cpu frequency.
> Thus, registering for a CPU freq notifier is very wasteful.
> 
> This patch modifes the code such that, i2c bus registers to
> cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.
> 
> This change should save a bunch of cpufreq transitions calls
> which does not apply to exynos SoCs.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes since v3:
> As per discussion at https://patchwork.kernel.org/patch/3235091/
> Post f023f8dd59 commit we should be using
> ARM_S3C24XX_CPUFREQ instead of CPU_FREQ_S3C24XX
> 
> upstrea linux kernel and linuxsamsung already has the commit
> f023f8dd59. Hence, rebasing the patch.
> 
>  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Wolfram, are you okay with this patch?

Best regards,
Tomasz

