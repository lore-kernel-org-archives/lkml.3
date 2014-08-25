Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaHYL2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:28:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64809 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaHYL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:28:39 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c6-53fb1de2c150
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, eduardo.valentin@ti.com,
        amit.daniel@samsung.com, rui.zhang@intel.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <edubezval@gmail.com>,
        linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
        robh+dt@kernel.org, galak@codeaurora.org, ch.naveen@samsung.com
Subject: Re: [PATCHv4 2/4] thermal: exynos: Add support for many TRIMINFO_CTRL
 registers
Date: Mon, 25 Aug 2014 13:28:29 +0200
Message-id: <1595080.7e4t1E1lOO@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <13170930.3cdcLOtxou@amdc1032>
References: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
 <53FB11E5.2070503@samsung.com> <13170930.3cdcLOtxou@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd1Hsr+DDdbsELdouBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFvOvXGO16H+zkNWid8FVNouzTW/YLTY9Bopd3jWHzeJz7xFGixnn
	9zFZLL1+kcliwvS1LBate4+wWzx52MfmIOixZt4aRo/Lfb1MHjtn3WX3WLznJZPHplWdbB6b
	l9R79G1Zxehx/MZ2Jo/Pm+QCOKO4bFJSczLLUov07RK4Mq4dnMla0KNWcWepWANjk1wXIyeH
	hICJxKUFrxkhbDGJC/fWs3UxcnEICSxilJjUfZAJwmlhkthwbBc7SBWbgJXExPZVYB0iAhoS
	M/9eYQQpYhbYziyx+fdvVpCEsECUxI4ZG5hBbBYBVYl1l3rBGngFNCUWtT4Di4sKeErs2L6S
	DcTmFNCWeLZgBTPUNkaJ1p1vmCEaBCV+TL7HAmIzC8hL7Ns/lRXC1pHY3zqNbQKjwCwkZbOQ
	lM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEPZPewbiqweIQowAHoxIP70rO
	X8FCrIllxZW5hxglOJiVRHh5RX8HC/GmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliS
	mp2aWpBaBJNl4uCUamDULz678ZBL2mGH1I+7r7V5Zbg3W7f6PyngfK0jKv9x4f1OacMVhSx1
	31dM7+BOfdth2Sub7KFyqTbhetO6ZVO9+/NP9/yu2V2Z0pNc9/X3NS75KUqq1oECSxbvi73q
	KHOjPyt16j+G+VvWC15O3f9v09sTh+743rnHeNzMetHFvQerpy3avM9OiaU4I9FQi7moOBEA
	+8ia1bQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 25, 2014 01:19:04 PM Bartlomiej Zolnierkiewicz wrote:
> On Monday, August 25, 2014 07:37:25 PM Chanwoo Choi wrote:
> > Hi Bartlomiej,
> > 
> > On 08/25/2014 07:15 PM, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > On Monday, August 25, 2014 04:30:23 PM Chanwoo Choi wrote:
> > >> This patch support many TRIMINFO_CTRL registers if specific Exynos SoC
> > >> has one more TRIMINFO_CTRL registers. Also this patch uses proper 'RELOAD'
> > >> shift/mask bit operation to set RELOAD feature instead of static value.
> > >>
> > >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > >> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > >> Cc: Zhang Rui <rui.zhang@intel.com>
> > >> Cc: Eduardo Valentin <edubezval@gmail.com>
> > >> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > >> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > >> ---
> > >>  drivers/thermal/samsung/exynos_thermal_common.h |  1 +
> > >>  drivers/thermal/samsung/exynos_tmu.c            | 23 ++++++++++++++++++++---
> > >>  drivers/thermal/samsung/exynos_tmu.h            |  9 +++++++--
> > >>  drivers/thermal/samsung/exynos_tmu_data.c       |  5 ++++-
> > >>  drivers/thermal/samsung/exynos_tmu_data.h       |  3 +++
> > >>  5 files changed, 35 insertions(+), 6 deletions(-)
> > >>
> > >> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
> > >> index 3eb2ed9..b211976 100644
> > >> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> > >> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> > >> @@ -28,6 +28,7 @@
> > >>  #define MAX_TRIP_COUNT	8
> > >>  #define MAX_COOLING_DEVICE 4
> > >>  #define MAX_THRESHOLD_LEVS 5
> > >> +#define MAX_TRIMINFO_CTRL_REG	2
> > >>  
> > >>  #define ACTIVE_INTERVAL 500
> > >>  #define IDLE_INTERVAL 10000
> > >> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > >> index acbff14..7234f38 100644
> > >> --- a/drivers/thermal/samsung/exynos_tmu.c
> > >> +++ b/drivers/thermal/samsung/exynos_tmu.c
> > >> @@ -147,7 +147,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> > >>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> > >>  	struct exynos_tmu_platform_data *pdata = data->pdata;
> > >>  	const struct exynos_tmu_registers *reg = pdata->registers;
> > >> -	unsigned int status, trim_info = 0, con;
> > >> +	unsigned int status, trim_info = 0, con, ctrl;
> > >>  	unsigned int rising_threshold = 0, falling_threshold = 0;
> > >>  	int ret = 0, threshold_code, i, trigger_levs = 0;
> > >>  
> > >> @@ -164,8 +164,25 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> > >>  		}
> > >>  	}
> > >>  
> > >> -	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
> > >> -		__raw_writel(1, data->base + reg->triminfo_ctrl);
> > >> +	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
> > >> +		if (reg->triminfo_ctrl_count > MAX_TRIMINFO_CTRL_REG) {
> > > 
> > > Please remove this check and MAX_TRIMINFO_CTRL_REG define.
> > > 
> > > We do not want such runtime checks for development time errors.
> > 
> > OK, I'll remove it.
> > 
> > > 
> > >> +			ret = -EINVAL;
> > >> +			goto out;
> > >> +		}
> > >> +
> > >> +		for (i = 0; i < reg->triminfo_ctrl_count; i++) {
> > >> +			if (pdata->triminfo_reload[i]) {
> > >> +				ctrl = readl(data->base +
> > >> +						reg->triminfo_ctrl[i]);
> > >> +				ctrl &= ~(reg->triminfo_reload_mask <<
> > >> +						reg->triminfo_reload_shift);
> > >> +				ctrl |= pdata->triminfo_reload[i] <<
> > >> +						reg->triminfo_reload_shift;
> > > 
> > > triminfo_reload_shift and triminfo_reload_mask variables have always
> > > the same values when this code is run so there is no need for them.
> > 
> > I don't understand. Do you mean that timinfo_reload_{shift/mask} variable is un-needed?
> 
> Yes.
> 
> > If you possible, I need more detailed comment.
> 
> Currently triminfo_reload_shift is always "0" and triminfo_reload_mask
> is "1" so there is no need to add an abstraction for different SoCs
> (it should be added only when there is a real need for it).
> 
> Please just rewrite this code as:
> 
> 			if (pdata->triminfo_reload[i]) {
> 				ctrl = readl(data->base +
> 						reg->triminfo_ctrl[i]);
> 				ctrl |= pdata->triminfo_reload[i];
> 				__raw_writel(ctrl, data->base +
> 						reg->triminfo_ctrl[i]);
> 			}

or even better lets get rid of the only __raw_writel() call in Exynos
thermal driver while at it:

			if (pdata->triminfo_reload[i]) {
				ctrl = readl(data->base +
						reg->triminfo_ctrl[i]);
				ctrl |= pdata->triminfo_reload[i];
				writel(ctrl, data->base +
						reg->triminfo_ctrl[i]);
			}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

