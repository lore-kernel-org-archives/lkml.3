Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaAaTUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:20:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaTUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:20:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
Date: Fri, 31 Jan 2014 20:20:16 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org> <1391107002-21470-3-git-send-email-galak@codeaurora.org>
In-Reply-To: <1391107002-21470-3-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401312020.16984.arnd@arndb.de>
X-Provags-ID: V02:K0:weQI7YvNCwmeQT+vSgN5NiZe9fVAIxrru5Dqb4JuGXw
 EY2DhwFCG5WPAGk5NtZI7S7MP6VYiN3iNtE0fbkMwXAigZEAU+
 TBTxfIodii7DbexfYWKNzScSx0zVWSCdSDh8kkZ/auUuMe1O5C
 /3VAlZgaHQpXnS1xeub3dFM2rpNpq0QxUioRIVBKHR/kQBBcaq
 Fh86ieCRzYPsoEXRoUbCeIRdUs/e2flfBB8iY/UNRMrBYRlLEm
 hQ31vjU6pADCLSfrKs4yn+RDI8fb2bsS2mRE7URIRwkMp4V2Zx
 zFPYoPOs40FheEJ59f1O6CVOVPbVJLcLayYcx0Tjl3ZDjG1Kzu
 PCbCiGgy4H70iqY8Z+m7+2Oks/1rghCv26ijqNopF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Kumar Gala wrote:
> Introduce a new mach-qcom that will support SoCs that intend to be
> multiplatform compatiable while keeping mach-msm to legacy SoC/board
> support that will not transition over to multiplatform.
> 
> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
> to mach-qcom.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>  MAINTAINERS                                        |  7 +++
>  arch/arm/Kconfig                                   |  7 +--
>  arch/arm/Makefile                                  |  1 +
>  arch/arm/boot/dts/Makefile                         |  6 +--
>  arch/arm/mach-msm/Kconfig                          | 45 +------------------
>  arch/arm/mach-msm/Makefile                         |  7 ---
>  arch/arm/mach-msm/hotplug.c                        | 51 ----------------------
>  arch/arm/mach-qcom/Kconfig                         | 34 +++++++++++++++
>  arch/arm/mach-qcom/Makefile                        |  5 +++
>  .../arm/{mach-msm/board-dt.c => mach-qcom/board.c} |  9 ++--
>  arch/arm/{mach-msm => mach-qcom}/scm-boot.c        |  0
>  arch/arm/{mach-msm => mach-qcom}/scm-boot.h        |  0
>  arch/arm/{mach-msm => mach-qcom}/scm.c             |  0
>  arch/arm/{mach-msm => mach-qcom}/scm.h             |  0
>  arch/arm/{mach-msm/platsmp.c => mach-qcom/smp.c}   | 11 ++++-

The hotplug.c change sticks out as something that isn't just a move
of code to another place, but deletion of unused code. It would
be nice to split that out into a separate change, possibly together
with the trivial board.c and smp.c changes.

	Arnd
