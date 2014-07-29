Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaG2JgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:36:06 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:56672 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaG2JgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:36:03 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <64ab74121712738db3a78e38cd383a56>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53D76AEB.3070908@rock-chips.com>
Date: Tue, 29 Jul 2014 17:35:39 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Doug Anderson <dianders@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>	<1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>	<20140721085001.GG8843@ulmo>	<53CD0E82.6030901@rock-chips.com>	<20140721132723.GH15238@ulmo>	<53D23192.4000908@rock-chips.com>	<CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>	<53D50601.1020106@rock-chips.com>	<CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>	<53D631B6.1050603@rock-chips.com> <CAOesGMgPDOQ0Z5b+d8nCiT4q_OGcYfv0zCb1naZVAqapaOtnPw@mail.gmail.com>
In-Reply-To: <CAOesGMgPDOQ0Z5b+d8nCiT4q_OGcYfv0zCb1naZVAqapaOtnPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Sorry, I didn't understand all of what you mean.
Please allow me to paste the following code [1].

在 2014年07月29日 00:58, Olof Johansson 写道:
> On Mon, Jul 28, 2014 at 4:19 AM, caesar <caesar.wang@rock-chips.com> wrote:
>> Doug,
>> 在 2014年07月28日 12:01, Doug Anderson 写道:
>>
>>> Caesar,
>>>
>>> On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com>
>>> wrote:
>>>> /*I think will be show the faill log:->
>>>>
>>>> * rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
>>>> 0xff9301a0-0xff93019f]
>>>> */
>>>>
>>>> pc->base = devm_ioremap_resource(dev, regs);
>>> Did you actually code this up and try it and get this error?
>> Yeah.
>>
>>> I hadn't
>>> tried it but I researched other dts files and it looked as if there
>>> was one example that was doing this.  ...but perhaps it wasn't
>>> actually doing the ioremap_resource on both ranges.
>>>
>>> I'd imagine that this is _probably_ equivalent to what Thierry was
>>> suggesting, so if it didn't work then maybe Thierry's won't work
>>> either?
>>>
>>> I don't have any other great suggestions other than doing two memory
>>> ranges for lcdc:
>>>
>>>            lcdc@ff930000 {
>>>                    compatible = "rockchip,rk3288-lcdc";
>>>                    reg = <0xff930000 0x1a0>, <0xff9301b0 0xfe50>;
>>>                    ...
>>>            };
>>>            pwm@ff9301a0 {
>>>                    compatible = "rockchip,vop-pwm";
>>>                    reg = <0xff9301a0 0x10>;
>>>                    ...
>>>            };
>>>
>>> ...but I am certainly nowhere near an expert on this stuff...
>>>
>>> -Doug
>>>
>>>
>>>
>> I has solve in lcdc driver,but I always feel awkward. I think a good way to
>> solve in pwm driver.
>> Unfortunately that  so far ,I have not a good idle in pwm driver.
>>
>> Maybe,I  let do it that way in lcdc driver.
> I think there's an easier way to do this, by not focusing _too_ much
> on the device tree:
>
> * Define a platform_data structure for the PWM driver, which contains
> readl/writel accessors as well as the device type (i.e. what you use
> the compatible field and the lookup table for today).
Maybe, as the following  code: "pwm_data_vop" has been implement it. right?
> * Populate the platform_device in the clcd driver, and register that
Yeah,the lcdc driver can register it.
> * Make the PWM driver probe as a regular platform device if pdata is passed
> * Make a readl/writel wrapper that either falls back to native
> readl/writel when there aren't any passed in, or make the DT code fill
> in the pdata with the native versions in that case.
Sorry,This step I don't understand it. Perhaps, could you give a simple 
case for it ?:-P

> Going full MFD on this seems overkill, unless there is also a shared
> interrupt that needs to be handled.
>
> -Olof
>
>
>
>

[1]:The driver/pwm/pwm-rockchip.c

#include <linux/clk.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/of_device.h>
#include <linux/platform_device.h>
#include <linux/pwm.h>
#include <linux/time.h>

#define PWM_CNTR        0x00        /* Counter register */
#define PWM_HRC            0x04        /* High reference register */
#define PWM_LRC            0x08        /* Low reference register */
#define PWM_CTRL        0x0c        /* Control register */
#define PWM_CTRL_TIMER_EN    (1 << 0)
#define PWM_CTRL_OUTPUT_EN    (1 << 3)

#define PRESCALER        2

#define PWM_ENABLE        (1 << 0)
#define PWM_CONTINUOUS        (1 << 1)
#define PWM_DUTY_POSITIVE    (1 << 3)
#define PWM_INACTIVE_NEGATIVE    (0 << 4)
#define PWM_OUTPUT_LEFT        (0 << 5)
#define PWM_LP_DISABLE        (0 << 8)

struct rockchip_pwm_chip {
     struct pwm_chip chip;
     struct clk *clk;
     const struct rockchip_pwm_data *data;
     void __iomem *base;
};

struct rockchip_pwm_regs {
     unsigned long duty;
     unsigned long period;
     unsigned long cntr;
     unsigned long ctrl;
};

struct rockchip_pwm_data {
     struct rockchip_pwm_regs regs;
     unsigned int prescaler;

     void (*set_enable)(struct pwm_chip *chip, bool enable);
};

static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct 
pwm_chip *c)
{
     return container_of(c, struct rockchip_pwm_chip, chip);
}

static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
{
     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
     u32 val = 0;
     u32 enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;

     val = readl_relaxed(pc->base + pc->data->regs.ctrl);

     if (enable)
         val |= enable_conf;
     else
         val &= ~enable_conf;

     writel_relaxed(val, pc->base + pc->data->regs.ctrl);
}

static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
{
     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
     u32 val = 0;
     u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
         PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;

     val = readl_relaxed(pc->base + pc->data->regs.ctrl);

     if (enable)
         val |= enable_conf;
     else
         val &= ~enable_conf;

     writel_relaxed(val, pc->base + pc->data->regs.ctrl);
}

static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device 
*pwm,
                    int duty_ns, int period_ns)
{
     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
     unsigned long period, duty;
     u64 clk_rate, div;
     int ret;

     clk_rate = clk_get_rate(pc->clk);

     /*
      * Since period and duty cycle registers have a width of 32
      * bits, every possible input period can be obtained using the
      * default prescaler value for all practical clock rate values.
      */
     div = clk_rate * period_ns;
     do_div(div, pc->data->prescaler * NSEC_PER_SEC);
     period = div;

     div = clk_rate * duty_ns;
     do_div(div, pc->data->prescaler * NSEC_PER_SEC);
     duty = div;

     ret = clk_enable(pc->clk);
     if (ret)
         return ret;

     writel(period, pc->base + pc->data->regs.period);
     writel(duty, pc->base + pc->data->regs.duty);
     writel(0, pc->base + pc->data->regs.cntr);

     clk_disable(pc->clk);

     return 0;
}

static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device 
*pwm)
{
     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
     int ret;

     ret = clk_enable(pc->clk);
     if (ret)
         return ret;

     pc->data->set_enable(chip, true);

     return 0;
}

static void rockchip_pwm_disable(struct pwm_chip *chip, struct 
pwm_device *pwm)
{
     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);

     pc->data->set_enable(chip, false);

     clk_disable(pc->clk);
}

static const struct pwm_ops rockchip_pwm_ops = {
     .config = rockchip_pwm_config,
     .enable = rockchip_pwm_enable,
     .disable = rockchip_pwm_disable,
     .owner = THIS_MODULE,
};

static const struct rockchip_pwm_data pwm_data_v1 = {
     .regs.duty = PWM_HRC,
     .regs.period = PWM_LRC,
     .regs.cntr = PWM_CNTR,
     .regs.ctrl = PWM_CTRL,
     .prescaler = PRESCALER,
     .set_enable = rockchip_pwm_set_enable_v1,
};

static const struct rockchip_pwm_data pwm_data_v2 = {
     .regs.duty = PWM_LRC,
     .regs.period = PWM_HRC,
     .regs.cntr = PWM_CNTR,
     .regs.ctrl = PWM_CTRL,
     .prescaler = PRESCALER-1,
     .set_enable = rockchip_pwm_set_enable_v2,
};

static const struct rockchip_pwm_data pwm_data_vop = {
     .regs.duty = PWM_LRC,
     .regs.period = PWM_HRC,
     .regs.cntr = PWM_CTRL,
     .regs.ctrl = PWM_CNTR,
     .prescaler = PRESCALER-1,
     .set_enable = rockchip_pwm_set_enable_v2,
};

static const struct of_device_id rockchip_pwm_dt_ids[] = {
     { .compatible = "rockchip,rk2928-pwm", .data = &pwm_data_v1},
     { .compatible = "rockchip,rk3288-pwm", .data = &pwm_data_v2},
     { .compatible = "rockchip,vop-pwm", .data = &pwm_data_vop},
     { /* sentinel */ }
};
MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);

static int rockchip_pwm_probe(struct platform_device *pdev)
{
     const struct of_device_id *id;
     struct rockchip_pwm_chip *pc;
     struct resource *r;
     int ret;

     id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
     if (!id)
         return -EINVAL;

     pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
     if (!pc)
         return -ENOMEM;

     r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
     pc->base = devm_ioremap_resource(&pdev->dev, r);
     if (IS_ERR(pc->base))
         return PTR_ERR(pc->base);

     pc->clk = devm_clk_get(&pdev->dev, NULL);
     if (IS_ERR(pc->clk))
         return PTR_ERR(pc->clk);

     ret = clk_prepare(pc->clk);
     if (ret)
         return ret;

     platform_set_drvdata(pdev, pc);

     pc->data = id->data;
     pc->chip.dev = &pdev->dev;
     pc->chip.ops = &rockchip_pwm_ops;
     pc->chip.base = -1;
     pc->chip.npwm = 1;

     ret = pwmchip_add(&pc->chip);
     if (ret < 0) {
         clk_unprepare(pc->clk);
         dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
     }

     return ret;
}

static int rockchip_pwm_remove(struct platform_device *pdev)
{
     struct rockchip_pwm_chip *pc = platform_get_drvdata(pdev);

     clk_unprepare(pc->clk);

     return pwmchip_remove(&pc->chip);
}

static struct platform_driver rockchip_pwm_driver = {
     .driver = {
         .name = "rockchip-pwm",
         .of_match_table = rockchip_pwm_dt_ids,
     },
     .probe = rockchip_pwm_probe,
     .remove = rockchip_pwm_remove,
};
module_platform_driver(rockchip_pwm_driver);

MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
MODULE_DESCRIPTION("Rockchip SoC PWM driver");
MODULE_LICENSE("GPL v2");

-Caesar

