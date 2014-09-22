Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaIVB1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:27:48 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:36604 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIVB1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:27:45 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: dh.herrmann@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <81615825368088ece1c0cbf4b43a65e3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <541F7B05.2000605@rock-chips.com>
Date: Mon, 22 Sep 2014 09:27:33 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v3 1/5] drm/rockchip: Add basic drm driver
References: <1411105668-32722-1-git-send-email-mark.yao@rock-chips.com>	<1411105668-32722-2-git-send-email-mark.yao@rock-chips.com> <CANq1E4Ti0yOQ+jCiXy7=NtFQ9cbWLOSLf6q-HWVdDFtMB1n29Q@mail.gmail.com>
In-Reply-To: <CANq1E4Ti0yOQ+jCiXy7=NtFQ9cbWLOSLf6q-HWVdDFtMB1n29Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月19日 21:04, David Herrmann wrote:
> Hi
>
> On Fri, Sep 19, 2014 at 7:47 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> [snip]
>> +static int rockchip_drm_bind(struct device *dev)
>> +{
>> +       return drm_platform_init(&rockchip_drm_driver, to_platform_device(dev));
> Please avoid drm_platform_*() usage. We're about to drop all the
> drm_bus midlayers. See the tegra driver how to do it, but basically
> just this:
OK, I will do it.
> struct drm_device *ddev;
>
> ddev = drm_dev_alloc(&rockchip_drm_driver, &to_platform_device(dev)->dev);
> if (!ddev)
>          return -ENOMEM;
>
> r = drm_dev_set_unique(ddev, dev_name(&ddev->dev));
> if (r < 0) {
>          drm_dev_unref(ddev);
>          return r;
> }
>
> r = drm_dev_register(ddev);
> if (r < 0) {
>          drm_dev_unref(ddev);
>          return r;
> }
>
>> +}
>> +
>> +static void rockchip_drm_unbind(struct device *dev)
>> +{
>> +       drm_put_dev(dev_get_drvdata(dev));
> Please use:
>
> struct drm_device *ddev = dev_get_drvdata(dev);
>
> drm_dev_unregister(ddev);
> drm_dev_unref(ddev);
>
>
> Thanks
> David
>
>
>


