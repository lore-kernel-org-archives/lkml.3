Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbaLKNzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:55:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44533 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbaLKNzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:55:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0b-5489a23aeefd
Message-id: <5489A227.8010907@samsung.com>
Date: Thu, 11 Dec 2014 14:54:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Tomasz Figa <tfiga@chromium.org>
Cc: linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Beata Michalska <b.michalska@samsung.com>
Subject: Re: [RFC PATCH 1/2] pm: Add PM domain notifications
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
 <1418286387-9663-2-git-send-email-tfiga@chromium.org>
 <548973B7.3050107@samsung.com>
 <CAAFQd5DrzYRCF3tW7cg=rZ3wB1G2kQtWbCx+Pby9obNTewsFdg@mail.gmail.com>
In-reply-to: <CAAFQd5DrzYRCF3tW7cg=rZ3wB1G2kQtWbCx+Pby9obNTewsFdg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e/4NV2rRZ0hBvd2mVhMm9HPbtE4Yz6r
	xdzZkxgt/j96zWqxYL+1RefsDewWXw+vYLSYNWUvk8Wmx9dYLS7vmsNm8bn3CKPFpwf/mS3u
	njrKZnHm9CVWi8+t/9gsjq8NdxDweHJwHpPH7IaLLB4Tz+p6LN7zksnjzrU9bB6bl9R7TL6x
	nNFjy9V2Fo++LasYPbZfm8fssWL1d3aPz5vkAniiuGxSUnMyy1KL9O0SuDIuXnvJVHBTuGL6
	hIPMDYzX+bsYOTkkBEwkbuy5zAJhi0lcuLeerYuRi0NIYCmjxOVz21ghnE+MEj82dTODVPEK
	aEl0v2kF62ARUJVY8vopmM0mYCjRe7SPEcQWFYiQOHl3DztEvaDEj8n3wGpEBFQkfp+cAbaB
	WWAJi0THnE9gQ4UFbCR6vvSwQGx7yCjxvx2im1MgWOJc+2+mLkYOoA51iSlTckHCzALyEpvX
	vGWewCgwC8mOWQhVs5BULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREn9fdjAuPmZ1
	iFGAg1GJh1cgtjNEiDWxrLgy9xCjBAezkgivVQRQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Ps
	hNDjK7svr2n72cH5sH9r5UOG9+3Vc0punl7KWz01beG0ms3Xf90Tu+EmqvF2qio7m14qs8Xc
	n+5blsqUvr4R/tvnSdK17f+XLS64X5d4oOfz1xBh5judcb+9t3j9X1r8+Pf/aLOgtUpqm6o2
	aO/0lutcm/b4T+x7rdbYcxvdZt7+9PnX5FenlFiKMxINtZiLihMBXZSYHZ0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 12:04, Tomasz Figa wrote:
...
>> > On 11/12/14 09:26, Tomasz Figa wrote:
>>> > > From: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> > >
>>> > > This patch adds notifiers to the runtime PM/genpd subsystem. It is now
>>> > > possible to register a notifier, which will be called before and after
>>> > > the generic power domain subsystem calls the power domain's power_on
>>> > > and power_off callbacks.
>>> > >
>>> > > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> > > [tfiga@chromium.org: rebased]
>>> > > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>> >
>> > Not sure if you've noticed it, I posted an updated version of this patch
>> > recently [1]. The notifiers list is moved to struct generic_pm_domain
>> > there and it also allows to register a notifier for selected power domain
>> > by name.
> [snip]
>> > [1] http://www.spinics.net/lists/linux-samsung-soc/msg38549.html
>
> Ah, haven't noticed, sorry. The API using devices looks the same, so I
> guess we can simply have patch 2/2 of this series applied on top of
> your patch.

Yes, that should work.

> By the way, look-up by name (presumably hardcoded somewhere?) sounds a
> bit strange to me. What was the reason for it to be added?

Yes, that might not be a very elegant approach. We initially used it
to implement power domain on/off sequence per specific domain and SoC,
since it appeared resistant to generalize.  I.e. the control register
write sequences are different per domain and per SoC (exynos).
So we named the domains in the device tree in that way:

	pm_domains: pm-domains@10024000 {
		compatible = "samsung,exynos4415-pd";
		reg-names = "cam", "tv", "mfc", "g3d",
		            "lcd0", "isp0", "isp1";
		reg = <0x10024000 0x20>, <0x10024020 0x20>,
		      <0x10024040 0x20>, <0x10024060 0x20>,
		      <0x10024080 0x20>, <0x100240A0 0x20>,
		      <0x100240E0 0x20>;
		#power-domain-cells = <1>;
	};

and then, for example, in the exynos CMU_ISP{0, 1} (clock controller)
driver registered for notification on "isp0" and "isp1" power domains
("isp1" is a sub-domain of "isp0" and the consumer devices are normally
attached to "isp1").

We have been investigating if we could do without the notification
at the clocks driver side, then the all SoC/power domain specific code
would end up in the exynos power domain driver. But I'm afraid it's
not going to work for all SoCs. Anyway lookup by name might be not
needed.


--
Regards,
Sylwester
