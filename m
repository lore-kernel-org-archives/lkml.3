Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3C0H65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:58:57 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:50407 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab3C0H64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:58:56 -0400
Message-ID: <5152A6A2.9030105@stericsson.com>
Date: Wed, 27 Mar 2013 08:58:26 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: ab8500: ambiguous meaning of delay setting in struct
 ab8500_regulator_info
References: <1364343321.13123.3.camel@phoenix>
In-Reply-To: <1364343321.13123.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 01:15 AM, Axel Lin wrote:
> Hi,
>
> The comment of struct ab8500_regulator_info says the delay means
> "startup/set voltage delay in us".
> I'm confused by the meaning, does it mean enable_time or set_voltage_time_sel
> time or both?
>
>   * @enable_time: Time taken for the regulator voltage output voltage to
>   *               stabilise after being enabled, in microseconds.
>
>   * @set_voltage_time_sel: Time taken for the regulator voltage output voltage
>   *               to stabilise after being set to a new value, in microseconds.
>   *               The function provides the from and to voltage selector, the
>   *               function should return the worst case.
The data sheet does not specify time delay for voltage selection, only 
enable time. So I have assumed the same time for voltage selection.
> Current code only has delay setting for AB8500_LDO_TVOUT, it looks like it
> means enable_time rather than the delay for set_voltage_time_sel.
> (well, AB8500_LDO_TVOUT is fixed voltage, it does not implement set_voltage_time_sel)
>
> ab8500_regulator_set_voltage_time_sel() returns info->delay, but all it's users
> (AB8500_LDO_AUX1, AB8500_LDO_AUX2, AB8500_LDO_AUX3, AB8500_LDO_INTCORE)
> do not has delay setting. ( So now ab8500_regulator_set_voltage_time_sel returns 0. )
This is a flaw in the driver. It should specify delay for all 
regulators, not just VTVout.

Worst case enable time from data sheet:
Vana: enable time = 140 us
Vaux1/2: enable time = 200 us
Vaux3: enable time = 450 us
Vintcore: enable time = 750 us
Vamic1/2: enable time = 500 us
Vdmic: enable time = 420 us
VTVout: enable time = 500 us
Vaudio: enable time = 140 us
Vusb: enable time = 150 us
>
> Axel
>
Thanks for looking into it.

Bengt
