Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaIWIMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:12:45 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57712 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIWIMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:12:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>, heiko@sntech.de,
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
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@r.null.null, ock-chips.com@null.null,
        xw@rock-chips.com
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Tue, 23 Sep 2014 10:11:34 +0200
Message-ID: <3217883.XVKPdbd6UA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54211CB1.6050002@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <3102396.6rAQmqkXXM@wuerfel> <54211CB1.6050002@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:cCPrMSJDY1NsMN9P17U/rFI8iWfbyGbGgEUS8VmTlnl
 +gRe+VgsUUtOU4gS4spO1Ehd7Ov2rovi1aN+O860IOsKDAvMB6
 aTIy2UG4BfB6X0ARtXokBDxk4aMSjlIl1tt5OAyahhIYB4Ostc
 InMczXfPuJ8yNfsvdA61vYnIDVD/WdkUua8l54+ff8mBtpOmCr
 ucgFUe1btiZHvmTw20doZr1NfMBeeP/KMccUFZI9qCpRtWqCjY
 flaN2l1t5FNQXKozIuQgEycOOC/w3h1mi9b8k/aOc/YRD5RY3a
 Mj581u6dusT5iCOYabFdiyu+m4EEGjnxdeHst9HAgxMvXzI+Pl
 zN1pJySLKWK06u7ctZqg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 15:09:37 Mark yao wrote:
> On 2014年09月22日 23:54, Arnd Bergmann wrote:
> > On Monday 22 September 2014 17:15:06 Boris BREZILLON wrote:
> >>>> +
> >>>> +   /* TODO(djkurtz): fetch the mapping start/size from somewhere */
> >>>> +   mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
> >>>> +                                      SZ_1G);
> >>>> +   if (IS_ERR(mapping)) {
> >>>> +           ret = PTR_ERR(mapping);
> >>>> +           goto err_config_cleanup;
> >>>> +   }
> >>>> +
> >>>> +   dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> >>> This is the default coherent mask. If you call this function, you
> >>> should normally check the return value, or call dma_set_mask first,
> >>> which you apparently don't do here, and in another place in this
> >>> patch.
> >> By "This is the default mask" do you mean it shouldn't be called at
> >> all ? Cause I ran into some trouble when not calling this in my
> >> atmel-hlcdc driver.
> > We used to get this wrong in the of_platform code, but it should
> > work now.
> >
> >> Actually, in my case the platform device is created by the MFD core
> >> which seems to let the coherent_dma_mask uninitialized.
> > That may well be different, but it seems like a good idea to allow
> > the MFD core to set this up as well.
> >
> > In general, we expect that devices that are capable of doing DMA
> > start with a 32-bit mask for both dma_mask and dma_coherent_mask,
> > and a driver that requires a smaller masks or wants a larger mask
> > has to call the appropriate interface to set these, and check the
> > return value.
> so I think we can use dma_set_mask_and_coherent(...) to set dma_mask and 
> dma_coherent_mark
> at the same time, and check the return value.

Yes, that would be good.

	Arnd
