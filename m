Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaLCBDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:03:52 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:49525 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCBDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:03:50 -0500
X-Greylist: delayed 35906 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 20:03:49 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: linux-rockchip@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <7258f400fa1fa5c5e84574e6449452fc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547E616C.1020503@rock-chips.com>
Date: Wed, 03 Dec 2014 09:03:40 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Jianqun Xu <jay.xu@rock-chips.com>
CC: xjq@rock-chips.com, Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, Sonny Rao <sonnyrao@chromium.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output
 clock to codec
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>	<1417531977-30094-1-git-send-email-jay.xu@rock-chips.com> <CAD=FV=Uwb1NxxCoXHzHu6DJCpnG_HV2RhCr3JaJaXbJja8kd7A@mail.gmail.com>
In-Reply-To: <CAD=FV=Uwb1NxxCoXHzHu6DJCpnG_HV2RhCr3JaJaXbJja8kd7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug:

在 12/03/2014 01:54 AM, Doug Anderson 写道:
> Jianqun,
> 
> This ought to be a "v3" patch and ideally ought to describe
> differences from v2 (after the cut).  Please have Kever or Chris
> review your next patch before sending it out since I think they are
> familiar with the process.
> 
> 
> On Tue, Dec 2, 2014 at 6:52 AM, Jianqun Xu <jay.xu@rock-chips.com> wrote:
>> From: Sonny Rao <sonnyrao@chromium.org>
>>
>> We need to claim the clock which is driving the codec so that when we enable
>> clock gating, we continue to clock the codec when needed.  I make this an
>> optional clock since there might be some applications where we don't need it
>> but can still use the I2S block.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> 
> You still forgot your own signed-off-by.  Please try again.  See
> <https://patchwork.kernel.org/patch/5334991/>
ok, I will add my signed-off-by
> 
> 
>> +       i2s->oclk = devm_clk_get(&pdev->dev, "i2s_clk_out");
>> +       if (IS_ERR(i2s->oclk)) {
>> +               dev_dbg(&pdev->dev, "Didn't find output clock\n");
>> +               i2s->oclk = NULL;
>> +       }
> 
> You still forgot the blank line here requested by Heiko.  Please try
> again.  See <https://patchwork.kernel.org/patch/5334991/>
Although I thought there needn't a blank ~, I wll add it next patch
> 
> 
>> +       if (i2s->oclk)
>> +               ret = clk_prepare_enable(i2s->oclk);
>> +
> 
> 
> 

-- 
Jianqun Xu

****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************

