Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3FOBfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:35:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53766 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3FOBfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:35:41 -0400
Date: Fri, 14 Jun 2013 18:35:46 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 3/3] msm clock for 3.11
Message-ID: <20130615013546.GV18124@quad.lixom.net>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
 <20130614195238.GA2381@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614195238.GA2381@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:52:55PM -0700, David Brown wrote:
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-clock-for-3.11
> 
> for you to fetch changes up to f54c1c11053d8aaf318a096b8b332fd41a394a66:
> 
>  ARM: msm: Migrate to common clock framework (2013-06-12 14:43:31 -0700)
> 
> ----------------------------------------------------------------
> MSM clock updates for 3.11.
> 
> Per Stephen Boyd's coverletter:
> 
> This patchset moves the existing MSM clock code and affected drivers
> to the common clock framework. A prerequisite of moving to the common
> clock framework is to use clk_prepare() and clk_enable() so the first
> few patches migrate drivers to that call (clk_prepare() is a no-op on
> MSM right now). It also removes some custom clock APIs that MSM
> provides and finally moves the proc_comm clock code to the common
> struct clk.
> 
> This patch series will be used as the foundation of the MSM 8660/8960
> clock code that I plan to send out after this series.
> 
> ----------------------------------------------------------------
> Stephen Boyd (12):
>      msm_serial: Convert to clk_prepare/unprepare
>      msm_serial: Use devm_clk_get() and properly return errors
>      usb: otg: msm: Convert to clk_prepare/unprepare
>      msm_sdcc: Convert to clk_prepare/unprepare
>      msm: iommu: Convert to clk_prepare/unprepare
>      msm: iommu: Use clk_set_rate() instead of clk_set_min_rate()
>      ARM: msm: Remove custom clk_set_flags() API
>      ARM: msm: Remove custom clk_set_{max,min}_rate() API
>      ARM: msm: Remove clock-7x30.h include file
>      ARM: msm: Prepare clk_get() users in mach-msm for clock-pcom driver
>      ARM: msm: Make proc_comm clock control into a platform driver
>      ARM: msm: Migrate to common clock framework

I don't see a single ack from any of the driver subsystem maintainers for
serial, usb or iommu. Some of them have been acked though, for example Felipe
acked the USB one on the mailing list.

I also didn't see Greg cc:d on the serial patches, which would explain why
there was no ack for them.

Care to repost/collect/rebuild this branch, please? It's a great cleanup and
I'd be happy to take it even if it ends up coming in after -rc6.


-Olof

