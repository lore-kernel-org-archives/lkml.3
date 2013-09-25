Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3IYODj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:03:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35090 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3IYODh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:03:37 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-0c-5242ed3685f3
From: Tomasz Figa <t.figa@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework to
 set APLL clock rate
Date: Wed, 25 Sep 2013 16:03:22 +0200
Message-id: <3068635.myUg9qMyJN@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <CAKew6eW9-QHL5NKHV8roER_yuoLEiCoS53Gby8zC841fr=whqQ@mail.gmail.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
 <CAKew6eW9-QHL5NKHV8roER_yuoLEiCoS53Gby8zC841fr=whqQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xq7pmb52CDL63mVtsnLGe1aJ3wVU2
	i/7Hr5kt3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVAFQt7mSw2fvWwmPu7kdWBx2Pn
	rLvsHptWdbJ53Lm2h81j3bS3zB59W1Yxejxa3MLo8XmTXAB7FJdNSmpOZllqkb5dAlfGna+H
	2Qt+81bc2rmFpYFxCXcXIyeHhICJxLe+O2wQtpjEhXvrgWwuDiGBpYwSD2cvZYVwupgkXhzc
	zgxSxSagJvG54RFYh4iAgcTEJfPAipgF7jNLvOhrZexi5OAQFkiV6J6ZAlLDIqAqcebjDDaQ
	MK+ApsS8ryEgYX4BdYl3254ygdiiAq4SnxZuZAcp4RQIlli7yBwkLCRwilFi4gFPEJtXQFDi
	x+R7LCA2s4C8xL79U1khbC2J9TuPM01gFJyFpGwWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07M
	LS7NS9dLzs/dxAiJnq87GJceszrEKMDBqMTD+6LJKUiINbGsuDL3EKMEB7OSCG/dC6AQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRsP/Qb4e8a27ed8sKIwJ/Ld1pl6Nsvwx107+FccNjW8ukHjb
	tljAqK/hvWVixo3OFCd+ngt1eR7HfTWvfUhae2V35CTego2ZGkybDrG4rfnid/zrzCtZc741
	rbhb9Gn7zyj+II77PdESjhWXLggc27+45dgR4w1V029V89t3tW79vOTvP63iZiWW4oxEQy3m
	ouJEAPscxY18AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

[resending in plain text, as my mail client somehow reset message 
format from plain back to HTML...]

On Wednesday 25 of September 2013 19:25:54 Yadwinder Singh Brar wrote:
> Hi Lukasz,
> 
> On Wed, Sep 25, 2013 at 4:52 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > In the exynos4x12_set_apll() function, the APLL frequency is set with
> > direct register manipulation.
> >
> > Such approach is not allowed in the common clock framework. The frequency
> > is changed, but the corresponding clock value is not updated. This causes
> > wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.
> >
> 
> This patch looks incomplete, leaving the driver in untidy state, perhaps its
> doesn't fix the above stated problem completely. what about
> if (!exynos4x12_pms_change(old_index, new_index)) becomes true?
> 
> IMHO, this driver needs lot more work in addition to this patch to cleanly and
> completely move the cpufreq driver to common clock framework.

I agree that the other case needs to be handled as well. Basically the
whole conditional block dependent on exynos4x12_pms_change() can be safely
dropped, because this condition is already handled in PLL driver.

Lukasz is already working on further rework of this driver to clean it up
from legacy code, but this will have to wait for 3.13, as 3.12 is already
in rc stage and only fixes can be accepted for it.

> For fixing this issue urgently, setting CLK_GET_RATE_NOCACHE for apll
> in clk driver can also be quicker fix.

Unfortunately this is not how this flag works. It only makes
clk_get_rate() call ->recalc_rate() operation of the clock instead of
instantly returning cached rate - it doesn't seem to work recursively.

Best regards,
Tomasz

