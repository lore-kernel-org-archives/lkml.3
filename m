Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaCKPUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:20:20 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27126 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaCKPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:20:16 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-6a-531f29ad0adc
Message-id: <1394551211.24263.34.camel@AMDC1943>
Subject: Re: [PATCH 1/3] mfd: max8997: use regmap to access registers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Tue, 11 Mar 2014 16:20:11 +0100
In-reply-to: <531F24C0.3070603@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
 <1394546304-15191-2-git-send-email-r.baldyga@samsung.com>
 <1394548336.24263.7.camel@AMDC1943> <531F24C0.3070603@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xq7prNeWDDSZsZrdYcvEqu8XUh0/Y
	LI7unMhkcf3Lc1aLSU/eM1scXvSC0WLiysnMFve/HmW0+Halg8ni5qdvrBaXd81hs9j6Zh2j
	xdojd9ktbjeuYLO4tvc4s8WDwzvZLXbvespqsb+zg9HidDerg7DHzll32T32TDzJ5rF5hZbH
	plWdbB53ru1h85h3MtBjz/wfrB59W1Yxekyf95PJ4/MmOY/1W7YyBXBHcdmkpOZklqUW6dsl
	cGV83vKHtWA+X8XUrUfYGxjXcXcxcnJICJhIbP7zngXCFpO4cG89G4gtJLCUUaJ/rmEXIxeQ
	/ZlR4n7vC3aQBK+AgcS/5b8ZQWxhAVeJSZu6WUFsNgFjic3Ll4A1iwhoSdz5OJ8dpJlZ4DCz
	xL4HHWBFLAKqEtPuXgBr5hTQlth/di4bxIZjjBILJkwH62YWUJeYNG8RM8RJShK72zvZIeLy
	EpvXvGWGuEJQ4sfkeywTGAVmIWmZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNz
	NzFC4vLLDsbFx6wOMQpwMCrx8M5Qkg8WYk0sK67MPcQowcGsJMKbLA4U4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwGhxeEtt2VcxSQNVnoz8GM94iRcLnsamWHOdjmRsSIr0aFiZfODWyxqdbfWq
	2jabYv9ZyTdpvfjx62DwaSH9kr+NRS2q6cZXTPyfOj2aU82sfmlH8rY2zVBuafu1r7jbQqel
	/NLrWC62ZeLh9+s9J72Zrvfh/72DDQ9knjJpL0h6uKR8Gvud50osxRmJhlrMRcWJAFRcG/ip	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 15:59 +0100, Robert Baldyga wrote:
> >> @@ -180,12 +167,12 @@ static struct irq_chip max8997_irq_chip = { 
> >> static irqreturn_t max8997_irq_thread(int irq, void *data) {
> >> struct max8997_dev *max8997 = data; -	u8
> >> irq_reg[MAX8997_IRQ_GROUP_NR] = {}; -	u8 irq_src; +	unsigned int
> >> irq_reg[MAX8997_IRQ_GROUP_NR] = {}; +	unsigned int irq_src; int
> >> ret; int i, cur_irq;
> >> 
> >> -	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, 
> >> &irq_src); +	ret = regmap_read(max8997->regmap,
> >> MAX8997_REG_INTSRC, &irq_src); if (ret < 0) { dev_err(max8997->dev,
> >> "Failed to read interrupt source: %d\n", ret); @@ -194,8 +181,9 @@
> >> static irqreturn_t max8997_irq_thread(int irq, void *data)
> >> 
> >> if (irq_src & MAX8997_IRQSRC_PMIC) { /* PMIC INT1 ~ INT4 */ - 
> >> max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4, - 
> >> &irq_reg[PMIC_INT1]); +		for (i = 0; i < 4; ++i) + 
> >> regmap_read(max8997->regmap, +				MAX8997_REG_INT1+i, 
> >> &irq_reg[PMIC_INT1+i]);
> > 
> > Can't you use here one bulk read instead of 4xregmap_read()?
> 
> Mixing regmap_read and regmap_bulk_read is not good idea, because the
> first function returns register value as unsigned int, but the second
> returns reg value to each single byte. So it would need to do some
> additional operations, and makes things more complicated.

The only mixing I see would be in reading FLASHSTATUS register which
could be resolved with:

if (irq_src & MAX8997_IRQSRC_FLASH) {
       /* Flash Status Interrupt */
       unsigned int data;
       ret = regmap_read(max8997->regmap, MAX8997_REG_FLASHSTATUS,
		       &data);
       irq_reg[FLASH_STATUS] = data;
}

This isn't more complicated than replacing bulk read with a loop :).

Best regards,
Krzysztof

