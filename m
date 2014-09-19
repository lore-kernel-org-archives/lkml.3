Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaISCEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:04:08 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:49949 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISCD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:03:58 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: mark.yao@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <50b09e8d64fbbb47cc4467b445753a40>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <541B8EDD.4090809@rock-chips.com>
Date: Fri, 19 Sep 2014 10:03:09 +0800
From: yaozq <yzq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org,
        kever.yang@rock-chips.com, dri-devel@lists.freedesktop.org,
        dianders@chromium.org, xjq@rock-chips.com, zyw@rock-chips.com,
        cym@rock-chips.com, linux-rockchip@lists.infradead.org,
        kfx@rock-chips.com, wxt@rock-chips.com, huangtao@rock-chips.com,
        devicetree@vger.kernel.org, yxj@rock-chips.com, marcheu@chromium.org,
        xxm@rock-chips.com, xw@rock-chips.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com
Subject: Re: [PATCH v2 1/5] drm/rockchip: Add basic drm driver
References: <1411032884-9233-1-git-send-email-mark.yao@rock-chips.com> <1411032991-9280-1-git-send-email-mark.yao@rock-chips.com> <20140918145214.GA15734@phenom.ffwll.local> <20140918145354.GB15734@phenom.ffwll.local>
In-Reply-To: <20140918145354.GB15734@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月18日 22:53, Daniel Vetter wrote:
> On Thu, Sep 18, 2014 at 04:52:14PM +0200, Daniel Vetter wrote:
>> On Thu, Sep 18, 2014 at 05:36:31PM +0800, Mark yao wrote:
>>> This patch adds the basic structure of a DRM Driver for Rockchip Socs.
>>>
>>> Signed-off-by: Mark yao <mark.yao@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - use the component framework to defer main drm driver probe
>>>    until all VOP devices have been probed.
>>> - use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
>>>    master device and each vop device can shared the drm dma mapping.
>>> - use drm_crtc_init_with_planes and drm_universal_plane_init.
>>> - remove unnecessary middle layers.
>>> - add cursor set, move funcs to rockchip drm crtc.
>>> - use vop reset at first init
>>> - reference framebuffer when used and unreference when swap out vop
>>>
>>> +static const struct drm_crtc_funcs rockchip_crtc_funcs = {
>>> +	.set_config = drm_crtc_helper_set_config,
>>> +	.page_flip = rockchip_drm_crtc_page_flip,
>>> +	.destroy = rockchip_drm_crtc_destroy,
>>> +	.cursor_set = vop_crtc_cursor_set,
>>> +	.cursor_move = vop_crtc_cursor_move,
>> If you expose your cursor plane as a universal you don't need to implement
>> these two cursor functions at all. Actually the core never calls them, see
>> drm_mode_cursor_universal. So if you want to expose cursors, please use
>> universal cursor plane support (like i915).
>>
>> In general that's how new drivers should expose cursors since without
>> universal planes support cursors will not be supported with the atomic
>> ioctl. Since your cursor code just calls the relevant plane functions that
>> should even simplify your driver ;-)
> Actually you already initialize with cursor universal planes, so all this
> code can simply be removed.
> -Daniel
I see, drm_mode_cursor_universal is nice, I would test and use it.
-Mark

