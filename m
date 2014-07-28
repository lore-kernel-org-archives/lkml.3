Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaG1LTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:19:33 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:52350 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaG1LTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:19:30 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <4e18cb4b4e1ce776cb10548e4a3efc26>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53D631B6.1050603@rock-chips.com>
Date: Mon, 28 Jul 2014 19:19:18 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pwm: add this patch to support the new pwm of
 Rockchip SoCs
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>	<1405774529-26027-3-git-send-email-caesar.wang@rock-chips.com>	<20140721085001.GG8843@ulmo>	<53CD0E82.6030901@rock-chips.com>	<20140721132723.GH15238@ulmo>	<53D23192.4000908@rock-chips.com>	<CAD=FV=XLjYQYmHxp3HBdwVmt6Wa7y-LEnsFKobsgVfFCp2-rRg@mail.gmail.com>	<53D50601.1020106@rock-chips.com> <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
In-Reply-To: <CAD=FV=UvF58NiY76FMi-TPVzsaWRJsR-M5HnHc7MRAWjwjY1jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,
在 2014年07月28日 12:01, Doug Anderson 写道:
> Caesar,
>
> On Sun, Jul 27, 2014 at 7:00 AM, caesar <caesar.wang@rock-chips.com> wrote:
>> /*I think will be show the faill log:->
>>
>> * rockchip-pwm ff9301a0.pwm: can't request region for resource [mem
>> 0xff9301a0-0xff93019f]
>> */
>>
>> pc->base = devm_ioremap_resource(dev, regs);
> Did you actually code this up and try it and get this error?
Yeah.
> I hadn't
> tried it but I researched other dts files and it looked as if there
> was one example that was doing this.  ...but perhaps it wasn't
> actually doing the ioremap_resource on both ranges.
>
> I'd imagine that this is _probably_ equivalent to what Thierry was
> suggesting, so if it didn't work then maybe Thierry's won't work
> either?
>
> I don't have any other great suggestions other than doing two memory
> ranges for lcdc:
>
>           lcdc@ff930000 {
>                   compatible = "rockchip,rk3288-lcdc";
>                   reg = <0xff930000 0x1a0>, <0xff9301b0 0xfe50>;
>                   ...
>           };
>           pwm@ff9301a0 {
>                   compatible = "rockchip,vop-pwm";
>                   reg = <0xff9301a0 0x10>;
>                   ...
>           };
>
> ...but I am certainly nowhere near an expert on this stuff...
>
> -Doug
>
>
>
I has solve in lcdc driver,but I always feel awkward. I think a good way 
to solve in pwm driver.
Unfortunately that  so far ,I have not a good idle in pwm driver.

Maybe,I  let do it that way in lcdc driver.


