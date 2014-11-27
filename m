Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaK0XoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:44:00 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60228 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaK0Xn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:43:58 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Alexandru M Stan <amstan@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        addy ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org, mark.yao@rock-chips.com
Subject: Re: [PATCH v4 0/2] Add support for the rockchip mmc clock phases using the framework
Date: Fri, 28 Nov 2014 00:47:14 +0100
Message-ID: <3766029.50NHsEnjv7@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1417051827-12564-1-git-send-email-amstan@chromium.org>
References: <1417051827-12564-1-git-send-email-amstan@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. November 2014, 17:30:25 schrieb Alexandru M Stan:
> For now all I have is the getter and setter for the phase, nothing that uses
> it (that is ready). You can test the getter like this:
> localhost ~ # cat /sys/kernel/debug/clk/clk_summary|grep sample -C 1
> sclk_sdio1                            0            0    24000000          0
> 0 sdio1_sample                       0            0    12000000          0
> 0 sdio1_drv                          0            0    12000000          0
> 90 --
> 	sclk_sdmmc                      1            1   297000000          0 0
> 		sdmmc_sample                 0            0   148500000          0 
134
> 		sdmmc_drv                    0            0   148500000          0 
90
> --
> 	sclk_sdio0                      1            1   100000000          0 0
> 		sdio0_sample                 0            0    50000000          0 0
> 		sdio0_drv                    0            0    50000000          0 
90
> 	sclk_emmc                       1            1   100000000          0 0
> 		emmc_sample                  0            0    50000000          0 0
> 		emmc_drv                     0            0    50000000          0 
180
> 
> Next thing that will come is some dts changes that will make use of these
> new clocks, and eventually mmc code will be changed to tune with these
> clocks. You can see some WIP on
> https://chromium-review.googlesource.com/#/c/227240

I've applied both patches to my clk branch.


Heiko
