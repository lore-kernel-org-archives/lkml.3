Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020Ab3CAMrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:47:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3693 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CAMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:47:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 01 Mar 2013 04:41:37 -0800
Message-ID: <5130A303.4060909@nvidia.com>
Date: Fri, 1 Mar 2013 18:15:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Graeme Gregory <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>, "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: use correct device node for DT parsing
References: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com> <512E16EE.2050201@slimlogic.co.uk> <20130301063915.GD25302@opensource.wolfsonmicro.com>
In-Reply-To: <20130301063915.GD25302@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013 12:09 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Feb 27, 2013 at 02:23:42PM +0000, Graeme Gregory wrote:
>> On 27/02/13 14:10, Laxman Dewangan wrote:
>>> When device is registered through the DT then regulators node
>>> exist in the parent device node of regulator driver. Hence passing
>>> parent device node for parsing DT in place of self-device node
>>> which is typically NULL.
>>> -	struct device_node *node = pdev->dev.of_node;
>>> +	struct device_node *node = pdev->dev.parent->of_node;
>> This is not correct, nor is the reasoning.
>> I suspect your previous patch broke DT probing so your not getting nodes
>> filled in.
> So, the reason that this pattern has generally been followed is so that
> the regulator core can do the equivalent of regulator_get(dev, supply)
> to find the supplies.  Using the parent device there is particularly
> important in non-DT systems so that we can map the child regulator
> supply in by using the dev_name() of the parent rather than the MFD
> internal subdevice name but for pure DT systems where it's all just
> direct links it's less of an issue.
>
>

If I make the dts file as
                         #gpio-cells = <2>;
                         gpio-controller;

                        palmas_pmic {
                                compatible = "ti,palmas-pmic";
                                ti,ldo6_vibrator = <0>;

                                regulators {
                                     :::::::::::::
                                 }
                         }


then regulator get registered properly.
And hence this patch is not require here.

