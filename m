Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbaCSMur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:50:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18001 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaCSMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:50:45 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-55-532992a2e6f2
Message-id: <1395233441.15174.8.camel@AMDC1943>
Subject: Re: [PATCH-next] mfd/rtc: s5m: Do not allocate RTC I2C dummy and
 regmap for unsupported chipsets
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Wed, 19 Mar 2014 13:50:41 +0100
In-reply-to: <20140319124720.GH31687@lee--X1>
References: <1395232095-7103-1-git-send-email-k.kozlowski@samsung.com>
 <20140319124720.GH31687@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7qLJmkGG8yeYm6x5OJVdouNM9az
	WpxtesNucf/rUUaLy7vmsFns7+xgtDj5p5fR4nQ3q8XFFV+YLNbPeM3iwOWxZ+JJNo871/aw
	ecw7GejRt2UVo8f0eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DK2L9yE1PBPs6KDU9WsDYwbmfv
	YuTkkBAwkVh5dy8rhC0mceHeerYuRi4OIYGljBJ3t+xngXA+M0o8f9LDDFLFK6Av8fvQJCCb
	g0NYIFviwREPkDCbgLHE5uVL2EDCIgIqEufemIO0Mgs8YZJ4e60HbAGLgKrEgbmzwWxOAV2J
	BxuawUYKCWRK/F/5mw3EZhZQl5g0bxEzxEFKErvbO9kh4vISm9e8hTpBUOLH5HssExgFZiFp
	mYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQiLh6w7GpcesDjEKcDAq8fBK
	xGoEC7EmlhVX5h5ilOBgVhLhbe3XDBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAuOjaMq45t05/
	TD1UGMEm4nilqH7pJNH1r4+td/9kwVhYfaVSSSfdLYjz3oGXNZf3+/m2HVcK23PHbUf+clPV
	qROFC1SD/KJLFHbmz7rwqnxSbOxmCwnOJb/f/EpRWp5ZV5W4X8NyIZNuzbkvT/nTrq00WHNB
	1ZprjWux+8r2kNkTcjViaxVeK7EUZyQaajEXFScCAL81TAFiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 12:47 +0000, Lee Jones wrote:
> > The rtc-s5m driver does not support all of S2M and S5M chipsets
> > supported by main MFD sec-core driver. For such chipsets unsupported by
> > rtc-s5m, the MFD sec-core driver initialized regmap with default config.
> > This config in such cases wouldn't work at all.
> > 
> > The main MFD sec-core driver shouldn't initialize regmap for child
> > drivers which is not used by them and even not valid.
> > 
> > Move the allocation of RTC I2C dummy device and initialization of RTC
> > regmap from main MFD sec-core driver to the rtc-s5m driver. The rtc-s5m
> > driver will use proper regmap config for supported devices.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c           |   53 +--------------------------
> >  drivers/rtc/rtc-s5m.c            |   75 +++++++++++++++++++++++++++++++++++---
> >  include/linux/mfd/samsung/core.h |    3 --
> >  3 files changed, 71 insertions(+), 60 deletions(-)
> 
> It's a bit late in the cycle for this kind of change. Would you mind
> re-sending after the v3.15 merge window please?

Sure, no problem.

Best regards,
Krzysztof

