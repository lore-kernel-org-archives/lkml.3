Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbaCTMqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:46:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63224 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbaCTMqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:46:00 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-79-532ae307585e
Message-id: <1395319557.22979.1.camel@AMDC1943>
Subject: Re: [PATCH v3 1/3] clk: s2mps11: Add support for S2MPS14 clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Thu, 20 Mar 2014 13:45:57 +0100
In-reply-to: <20140319191117.30995.13715@quantum>
References: <1395047958-17953-1-git-send-email-k.kozlowski@samsung.com>
 <1395047958-17953-2-git-send-email-k.kozlowski@samsung.com>
 <20140319001643.30995.46947@quantum> <1395215408.18730.2.camel@AMDC1943>
 <20140319191117.30995.13715@quantum>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xK7rsj7WCDZYuYrbYOGM9q8XZpjfs
	Fve/HmW02PT4GqvF5V1z2CxmnN/HZLH2yF12i6cTLrJZnPzTy2hxupvV4uKKL0wW62e8ZrFo
	/7uXzWLO9HdMDnwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK6Gj+
	zV6wn6/izee4BsYF3F2MnBwSAiYSax+8YISwxSQu3FvP1sXIxSEksJRRYtPvBUwQzmdGiX3z
	HrGAVPEK6EtMXbOYHcQWFvCQmDH7B5jNJmAssXn5EjYQW0TAR+L56x1gzcwCn5kl3k99D1bE
	IqAqsWTlK2YQm1PAUGL15CdgtpDAd0aJb6+KQWxmAXWJSfMWMUOcpCSxu72THSIuL7F5zVtm
	iCMEJX5MvscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJE6+
	7GBcfMzqEKMAB6MSD++KPZrBQqyJZcWVuYcYJTiYlUR4p97QChbiTUmsrEotyo8vKs1JLT7E
	yMTBKdXAaB+Twz7xvHLG2Yddf6+K7fii8nMi72bzpqJ9Gt6/fwvM0t6k/Sj8RLCN5soqx4wr
	F2T8p79/KbvNaP3/HVyWW2Nf7X3Z5qBpdnTPUdUNdySl9d6f2+XNy9jx9sNruaD2qVsSDrJE
	2YgGmZjHf8go/7rqztLLfAdDf19kKlnN8L46bu5L/hKet0osxRmJhlrMRcWJAKQ2RS9xAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 12:11 -0700, Mike Turquette wrote:
> Quoting Krzysztof Kozlowski (2014-03-19 00:50:08)
> > On Tue, 2014-03-18 at 17:16 -0700, Mike Turquette wrote:
> > > Quoting Krzysztof Kozlowski (2014-03-17 02:19:16)
> > > > This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
> > > > s2mps11 clock driver.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > > > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > > 
> > > This does not apply cleanly to to clk tree trip, nor does it compile
> > > after manually merging due to changes introducing
> > > linux/mfd/samsung/s2mps14.h.
> > > 
> > > The changes look OK to me so maybe Lee can take it with my Ack?
> > > 
> > > Acked-by: Mike Turquette <mturquette@linaro.org>
> > > 
> > 
> > Hi,
> > 
> > Thanks for the Ack. The patch depends on Tushar Behera's patches:
> >  - [PATCH V2 0/2] Add support for clocks in S5M8767
> >    http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27264
> > which are waiting for some time. Both patchsets should be pulled
> > together.
> 
> I took those patches in yesterday. So we have three options:

Great! Thanks.

> 
> 1) MFD tree can pull a stable commit from the clk tree. I'm happy to
> make a topic branch for this. Then these patches can be applied.
> 
> 2) clk tree can pull a stable commit from the mfd tree if the mfd folks
> can provide one.
> 
> 3) Wait until after the merge window to apply this one to the clk tree.
> I don't currently plan to send 2 PRs during the merge window, so this
> could either go in 3.16 or maybe into 3.15 if a split PR is sent.

Dear Lee,

How do you wish to proceed? The patchset depends on changes in sec-core
MFD driver.

Best regards,
Krzysztof


