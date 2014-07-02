Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbaGBTnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:43:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56361 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbaGBTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:43:22 -0400
Message-ID: <53B460B4.9010200@ti.com>
Date: Wed, 2 Jul 2014 14:42:44 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 05/15] hwspinlock/omap: add support for dt nodes
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-6-git-send-email-s-anna@ti.com> <CAK=WgbamDPN9EmKUu3+c3RbsQn1uhz5MGGvpWSSUJSUKyoH8Cw@mail.gmail.com>
In-Reply-To: <CAK=WgbamDPN9EmKUu3+c3RbsQn1uhz5MGGvpWSSUJSUKyoH8Cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/01/2014 07:48 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>>  static int omap_hwspinlock_probe(struct platform_device *pdev)
>>  {
>> -       struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
>> +       struct device_node *node = pdev->dev.of_node;
>>         struct hwspinlock_device *bank;
>>         struct hwspinlock *hwlock;
>>         struct resource *res;
>>         void __iomem *io_base;
>>         int num_locks, i, ret;
>> +       int base_id = 0;
> 
> We shouldn't implicitly assume base_id is zero: let's explicitly
> protect against potential subsequent invocations of
> omap_hwspinlock_probe.
> 

Yeah, I did this since we only had 1 instance, and used the same value
as used in the non-DT legacy code. Once I fold back Patch 8 that adds
the hwlock-base-id property, this will be assigned by reading that property.

regards
Suman

