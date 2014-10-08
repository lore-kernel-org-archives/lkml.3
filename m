Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaJHTTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:19:08 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:49329 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaJHTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <1409672443-4289-4-git-send-email-gdjakov@mm-sol.com>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com> <1409672443-4289-4-git-send-email-gdjakov@mm-sol.com>
From: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Date: Wed, 8 Oct 2014 21:18:44 +0200
Message-ID: <CAP71WjxYibPGBC=x4eA-Lmjg_Mc7cCB20VSvf59C_AW7PYNE=A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, iivanov@mm-sol.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Georgi,

On Tue, Sep 2, 2014 at 5:40 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> Enable support for the two SD host controllers on the APQ8084 platform
> by adding the required nodes to the DT files.
> On the IFC6540 board, the first controller is connected to the onboard
> eMMC and the second is connected to a micro-SD card slot.

testing this set of patch on IFC6540, i noticed that not all
partitions from the eMMC are detected. booting [1] which is basically
3.17-rc7 with a few additional patches, i can see the following
relevant mmc traces:

[    1.162587] mmc0: BKOPS_EN bit is not set
[    1.315357] mmc0: new HS200 MMC card at address 0001
[    1.318098] mmcblk0: mmc0:0001 SEM16G 14.6 GiB
[    1.330377] mmcblk0boot0: mmc0:0001 SEM16G partition 1 4.00 MiB
[    1.333652] mmcblk0boot1: mmc0:0001 SEM16G partition 2 4.00 MiB
[    1.345424] mmcblk0rpmb: mmc0:0001 SEM16G partition 3 4.00 MiB
[    1.358135]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15
[    1.365902]  mmcblk0boot1: p1
[    1.367833]  mmcblk0boot0: unknown partition table

on the same board, booting the board vendor kernel (which is based on
QCOM 3.10 tree), i can see much more partitions:

[    7.662379] mmc0: BKOPS_EN bit = 0
[    7.673036] mmc0: new HS200 MMC card at address 0001
[    7.673784] mmcblk0: mmc0:0001 SEM16G 14.6 GiB
[    7.674311] mmcblk0rpmb: mmc0:0001 SEM16G partition 3 4.00 MiB
[    7.677967]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13
p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24\
 p25

the complete dmesg log for can be found in our board lab, at [2]

cheers

[1] https://git.linaro.org/landing-teams/working/qualcomm/kernel.git/commit/b538bdefecd11bd0278cc31164e1078c1722e5a8
[2] http://armv7.com/scheduler/job/11726/log_file#L_11_11
