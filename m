Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3IZGO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:14:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47459 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3IZGO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:14:57 -0400
MIME-Version: 1.0
In-Reply-To: <3068635.myUg9qMyJN@amdc1227>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
	<1380108138-30402-2-git-send-email-l.majewski@samsung.com>
	<CAKew6eW9-QHL5NKHV8roER_yuoLEiCoS53Gby8zC841fr=whqQ@mail.gmail.com>
	<3068635.myUg9qMyJN@amdc1227>
Date: Thu, 26 Sep 2013 11:44:56 +0530
Message-ID: <CAKew6eVXw5qUuZ=Oc6ko3BkJj=iYqvN-NsrfmOHPQmMkxiv-nA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework
 to set APLL clock rate
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

>> On Wed, Sep 25, 2013 at 4:52 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
>> > In the exynos4x12_set_apll() function, the APLL frequency is set with
>> > direct register manipulation.
>> >
>> > Such approach is not allowed in the common clock framework. The frequency
>> > is changed, but the corresponding clock value is not updated. This causes
>> > wrong frequency read from cpufreq's cpuinfo_cur_freq sysfs attribute.
>> >
>>
>> This patch looks incomplete, leaving the driver in untidy state, perhaps its
>> doesn't fix the above stated problem completely. what about
>> if (!exynos4x12_pms_change(old_index, new_index)) becomes true?
>>
>> IMHO, this driver needs lot more work in addition to this patch to cleanly and
>> completely move the cpufreq driver to common clock framework.
>
> I agree that the other case needs to be handled as well. Basically the
> whole conditional block dependent on exynos4x12_pms_change() can be safely
> dropped, because this condition is already handled in PLL driver.
>

Exactly!

> Lukasz is already working on further rework of this driver to clean it up
> from legacy code, but this will have to wait for 3.13, as 3.12 is already
> in rc stage and only fixes can be accepted for it.
>
>> For fixing this issue urgently, setting CLK_GET_RATE_NOCACHE for apll
>> in clk driver can also be quicker fix.
>
> Unfortunately this is not how this flag works. It only makes
> clk_get_rate() call ->recalc_rate() operation of the clock instead of
> instantly returning cached rate - it doesn't seem to work recursively.
>

hmm.. yes it can't help in our case as it recursively walks only the subtree
of clk but in our case we are changing rate of parent.

Regards,
Yadwinder
