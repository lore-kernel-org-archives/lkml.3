Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaIWHJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:09:49 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:56118 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIWHJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:09:47 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: arnd@arndb.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <4fc72f82c1ec9cedf135c7b318fdc600>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54211CB1.6050002@rock-chips.com>
Date: Tue, 23 Sep 2014 15:09:37 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: heiko@sntech.de, David Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@r.NULL.NULL, ock-chips.com@NULL.NULL,
        xw@rock-chips.com
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <3036415.u40f3Xnhod@wuerfel> <20140922171506.31d59a76@bbrezillon> <3102396.6rAQmqkXXM@wuerfel>
In-Reply-To: <3102396.6rAQmqkXXM@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月22日 23:54, Arnd Bergmann wrote:
> On Monday 22 September 2014 17:15:06 Boris BREZILLON wrote:
>>>> +
>>>> +   /* TODO(djkurtz): fetch the mapping start/size from somewhere */
>>>> +   mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
>>>> +                                      SZ_1G);
>>>> +   if (IS_ERR(mapping)) {
>>>> +           ret = PTR_ERR(mapping);
>>>> +           goto err_config_cleanup;
>>>> +   }
>>>> +
>>>> +   dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
>>> This is the default coherent mask. If you call this function, you
>>> should normally check the return value, or call dma_set_mask first,
>>> which you apparently don't do here, and in another place in this
>>> patch.
>> By "This is the default mask" do you mean it shouldn't be called at
>> all ? Cause I ran into some trouble when not calling this in my
>> atmel-hlcdc driver.
> We used to get this wrong in the of_platform code, but it should
> work now.
>
>> Actually, in my case the platform device is created by the MFD core
>> which seems to let the coherent_dma_mask uninitialized.
> That may well be different, but it seems like a good idea to allow
> the MFD core to set this up as well.
>
> In general, we expect that devices that are capable of doing DMA
> start with a 32-bit mask for both dma_mask and dma_coherent_mask,
> and a driver that requires a smaller masks or wants a larger mask
> has to call the appropriate interface to set these, and check the
> return value.
so I think we can use dma_set_mask_and_coherent(...) to set dma_mask and 
dma_coherent_mark
at the same time, and check the return value.
> 	Arnd
>
>
>


