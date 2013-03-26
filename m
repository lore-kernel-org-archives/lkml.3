Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3CZHuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:50:50 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34112 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362Ab3CZHus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:50:48 -0400
MIME-Version: 1.0
X-Originating-IP: [218.173.168.234]
In-Reply-To: <515151A5.3090306@stericsson.com>
References: <1364280647.16881.1.camel@phoenix>
	<515151A5.3090306@stericsson.com>
Date: Tue, 26 Mar 2013 15:50:48 +0800
Message-ID: <CAFRkauCsS1NZdWHnL21CrEuXMnKD1+2FY+bPftwR-UuhyL8vnQ@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT] regulator: ab8500: Remove is_enabled from struct ab8500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/26 Bengt Jönsson <bengt.g.jonsson@stericsson.com>:
> On 03/26/2013 07:50 AM, Axel Lin wrote:
>>
>> The is_enabled flag looks not necessary at all, it also introduces some
>> issues
>> because current code updates info->is_enabled flag in error paths of
>> ab8500_regulator_enable() and ab8500_regulator_disable().
>> Thus this patch removes is_enabled from struct ab8500_regulator_info.
>>
>> This patch also removes info->is_enabled checking in
>> ab8500_regulator_set_mode(),
>> so it allows setting mode even the regulator is disabled.
>
> This patch will change the behaviour of set_mode as the ab8500 regulators
> share mode and enable in the same register bits:
> - off = 0b00
> - low power mode= 0b11
> - full powermode = 0b01
> - (HW control mode = 0b10)
>
> To keep regulator_enable/disable apart from regulator_set_mode I think this
> patch should not go in.

Thanks for the review.
I'll send a patch to avoid update is_enabled flag in error paths.

Axel
