Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3CZHnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:43:52 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:55717 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756973Ab3CZHnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:43:50 -0400
Message-ID: <515151A5.3090306@stericsson.com>
Date: Tue, 26 Mar 2013 08:43:33 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT] regulator: ab8500: Remove is_enabled from struct
 ab8500_regulator_info
References: <1364280647.16881.1.camel@phoenix>
In-Reply-To: <1364280647.16881.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 07:50 AM, Axel Lin wrote:
> The is_enabled flag looks not necessary at all, it also introduces some issues
> because current code updates info->is_enabled flag in error paths of
> ab8500_regulator_enable() and ab8500_regulator_disable().
> Thus this patch removes is_enabled from struct ab8500_regulator_info.
>
> This patch also removes info->is_enabled checking in ab8500_regulator_set_mode(),
> so it allows setting mode even the regulator is disabled.
This patch will change the behaviour of set_mode as the ab8500 
regulators share mode and enable in the same register bits:
- off = 0b00
- low power mode= 0b11
- full powermode = 0b01
- (HW control mode = 0b10)

To keep regulator_enable/disable apart from regulator_set_mode I think 
this patch should not go in.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> This patch also removes info->is_enabled checking in ab8500_regulator_set_mode().
> I'm not very clear if we should avoid setting mode when the regulator is disabled.
> It looks to me if we don't want to allow setting mode when regulator is disabled,
> this checking should be done in regulator-core.
Checking in regulator-core seems like a good idea to me.It would make 
the ab8500 code more clean, but I don't know how other drivers will be 
affected.
> Seems current code in other regulator drivers does not check if regulator is
> enabled or not in set_mode callback implementation.
> Axel
I know some other hardware has separate register bits for mode and 
enable which matches the framework better.

Bengt
