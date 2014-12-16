Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaLPAJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:09:08 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40703 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLPAJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:09:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1qeaHfsq1xOOBMQc58uSvV4unuEWHjqVpiZrpu2bQD36LbXg@mail.gmail.com>
References: <1418685929-13096-1-git-send-email-dianders@chromium.org>
	<1418685929-13096-2-git-send-email-dianders@chromium.org>
	<CAL1qeaHfsq1xOOBMQc58uSvV4unuEWHjqVpiZrpu2bQD36LbXg@mail.gmail.com>
Date: Mon, 15 Dec 2014 16:09:05 -0800
X-Google-Sender-Auth: L3qZCOTJdeBLP1TVHi_-2C5zjjo
Message-ID: <CAD=FV=XigXJWg1PiFzA20xXz-6VY=OGnGefJfvoVOiajq5Aicg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mmc: dw_mmc: Use mmc_regulator_set_vqmmc in start_signal_voltage_switch
From: Doug Anderson <dianders@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Mark Brown <broonie@kernel.org>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Mon, Dec 15, 2014 at 3:44 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:
>> -       if (!IS_ERR(mmc->supply.vqmmc)) {
>> -               ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
>> -
>> -               if (ret) {
>> -                       dev_dbg(&mmc->class_dev,
>> -                                        "Regulator set error %d: %d - %d\n",
>> -                                        ret, min_uv, max_uv);
>> -                       return ret;
>> -               }
>> -       }
>> +       mmc_regulator_set_vqmmc(mmc, ios);
>
> Shouldn't we check the return value here and bail out of the voltage
> switch procedure if it fails?

My thought was to purposely _not_ check the return value.  The comment
right above this says:

* Program the voltage.  Note that some instances of dw_mmc may use
* the UHS_REG for this.  For other instances (like exynos) the UHS_REG
* does no harm but you need to set the regulator directly.  Try both.

...I'm not 100% sure that I understand how the UHS_REG is supposed to
be implemented since I've never seen a system that uses it.  I was
assuming that if you have UHS_REG you don't need the regulator...

...but probably a better solution is to return the error if "
!IS_ERR(mmc->supply.vqmmc)".  Let me fix that up and repost.


-Doug
