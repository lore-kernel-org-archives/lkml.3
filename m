Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3LJJaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:30:15 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51058 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3LJJaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:30:10 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f966d0000003d9-58-52a6df202c48
Content-transfer-encoding: 8BIT
Message-id: <1386667806.4008.2.camel@AMDC1943>
Subject: Re: [TRIVIAL PATCH 1/2] regulator: s5m8767: Define symbol for buck
 control mask
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Kosina <trivial@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Tue, 10 Dec 2013 10:30:06 +0100
In-reply-to: <CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
In-reply-to: <CAK9yfHwz0Swi=vBu_Wynsr5ZDMDfwnFxS1p2Sc6ofabiotEa1w@mail.gmail.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xy7oK95cFGSy4w2Ix9eETNouzTW/Y
	Le5/Pcpo8e1KB5PFpsfXWC0u75rDZrH2yF12i5N/ehktTnezWlxc8YXJ4v3+y0wO3B47Z91l
	99i0qpPN4861PWwe804GemxeUu/Rt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGQ9etrIV7Oao
	uLFatoHxCVsXIyeHhICJxJn5k9ghbDGJC/fWg8WFBJYySkzfJwRi8woISvyYfI+li5GDg1lA
	XuLIpWyQMLOAusSkeYuYuxi5gMo/M0rsnNHDDFGvJ/Hv8TJGEFtYIEri4LyprCA2m4CxxObl
	S8DmiwhoSbzsXs4E0swsMINZ4srtdmaQBSwCqhJXZwWD1HAKBEscmPCSCWJBL6PEvhMNLGgc
	ZFUgHyhJ7G7vZJ/AKDQLyeGzEA6fheTwBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFC
	IunLDsbFx6wOMQpwMCrx8BYwLAsSYk0sK67MPcQowcGsJMK7+iRQiDclsbIqtSg/vqg0J7X4
	ECMTB6dUA2PIktNPp+WLTFLL86lT1HRWPsenmDvNMad9x32vCyfnHvat0jS1t3AtNXx+bXPa
	gUMlSRdNxGVW3Fi6aKbb5cIzyTf+Wmx5u5p1hnQZw+vlxqEmKStKCy2EXp8+Nkfd1/6s3IWP
	Vtu2qdzyqGw+Pf/avFiOrPafh3jLevZtv5nw4lJzxQ8mgQ9KLMUZiYZazEXFiQAcg344ggIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 14:48 +0530, Sachin Kamat wrote:
> Hi Krzysztof,
> 
> On 10 December 2013 14:39, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
> >  static int s5m8767_reg_disable(struct regulator_dev *rdev)
> >  {
> >         struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
> >         int ret, reg;
> > -       int  mask = 0xc0, enable_ctrl;
> > +       int mask = S5M8767_ENCTRL_MASK, enable_ctrl;
> 
> Couldn't we get rid of this mask variable here too?
> 
> Otherwise the patch looks good to me.

Not in this patch because it leads to warning:

drivers/regulator/s5m8767.c: In function ‘s5m8767_reg_disable’:
drivers/regulator/s5m8767.c:259:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]
drivers/regulator/s5m8767.c:253:6: warning: unused variable ‘mask’ [-Wunused-variable]

I plan to remove the sec_reg_*() helpers because they are confusing
and error-prone (mixing u8 and unsigned int). After using standard regmap
API this "mask" variable could be removed.

Best regards,
Krzysztof


