Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaE0DXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:23:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60523 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaE0DXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:23:36 -0400
Message-ID: <538404F2.9000505@ti.com>
Date: Tue, 27 May 2014 08:52:26 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>
Subject: Re: [PATCH 5/5] regulator: tps65917: Add Regulator driver for tps65917
 PMIC
References: <1401098197-647-1-git-send-email-j-keerthy@ti.com> <1401098197-647-6-git-send-email-j-keerthy@ti.com> <20140526150052.GP22111@sirena.org.uk>
In-Reply-To: <20140526150052.GP22111@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Monday 26 May 2014 08:30 PM, Mark Brown wrote:
> On Mon, May 26, 2014 at 03:26:37PM +0530, Keerthy wrote:
>> This patch adds support for TPS65917 PMIC regulators.
>>
>> The regulators set consists of 5 SMPSs and 5 LDOs. The output
>> voltages are configurable and are meant to supply power to the
>> main processor and other components.
> This appears to look *very* like the Palmas driver, should it not be
> sharing code with that?  If it were just data tables it'd be less of a
> concern but there's quite a bit of actual code here.
Yes it is. The difference is in the entire register space of the regulators
between the two. There are other differences in how the ramp delay
is configured and SMPS ordering. The difference is also a bit in the 
programming
sequence. I agree that largely it is Palmas based. I did not want to add 
more
checks in the probe of the palmas driver. Hence came up with a new one.

Coming to sharing the code, can we have 2 drivers which share the common
functions with separate data and specific functions?

I just simply do not want to add anything more to the palmas driver 
probe function.

Kind Regards,
Keerthy
