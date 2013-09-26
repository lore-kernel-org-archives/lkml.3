Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3IZJQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:16:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50173 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3IZJQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:16:34 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-b0-5243fb70c30e
Date: Thu, 26 Sep 2013 11:16:25 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: exynos4x12: Use the common clock framework to
 set APLL clock rate
Message-id: <20130926111625.09cb2071@amdc308.digital.local>
In-reply-to: <CAKew6eVXw5qUuZ=Oc6ko3BkJj=iYqvN-NsrfmOHPQmMkxiv-nA@mail.gmail.com>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1380108138-30402-2-git-send-email-l.majewski@samsung.com>
 <CAKew6eW9-QHL5NKHV8roER_yuoLEiCoS53Gby8zC841fr=whqQ@mail.gmail.com>
 <3068635.myUg9qMyJN@amdc1227>
 <CAKew6eVXw5qUuZ=Oc6ko3BkJj=iYqvN-NsrfmOHPQmMkxiv-nA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xgG7Bb+cgg+5ueYuNM9azWvQuuMpm
	0f/4NbPFm0fcFpd3zWGz+Nx7hNFixvl9TBa3G1cAJRf2Mlmc/NPLaLF+xmsWi41fPSzm/m5k
	deD12DnrLrvHplWdbB53ru1h81g37S2zR9+WVYwejxa3MHp83iQXwB7FZZOSmpNZllqkb5fA
	lbHq92SmgulCFb2HzBsYZ/B1MXJySAiYSLyZ28wCYYtJXLi3ng3EFhJYxCgx66ZAFyMXkN3O
	JLHm8W1GkASLgKrEvKeHwRrYBPQkPt99ygRiiwjUSGw8u5cRpIFZYDOzxPMZW5i7GDk4hAVS
	JbpnpoDU8ApYS2xqbGIDCXMKBEusWiUKMX8jk8Tsc8/A5vALSEq0//vBDHGQncS5TxvYIXoF
	JX5Mvge2l1lAS2LztiZWCFteYvOat8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGC4+iZ9A7GVQ0WhxgFOBiVeHgvMDsHCbEmlhVX5h5ilOBgVhLhXfcRKMSb
	klhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFxgn+DVVW/ufzv
	yYyuB58X2Uhqt/tn/klRm5u2nDtqeQHPga0SDce8es3ulbL5thzhNJjiWpT6t0WCtbTKedJl
	wVs3pq9ftcqLuei74cTFb22CFx/eoOLWveiU3fojm82irI4/8Pr78fq6n2Im3KGnjq6Vs1ym
	o8eytUYhb2PKp+RAZ8/KGiYlluKMREMt5qLiRAAlE2ulnwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

> Hi Tomasz,
> 
> >> On Wed, Sep 25, 2013 at 4:52 PM, Lukasz Majewski
> >> <l.majewski@samsung.com> wrote:
> >> > In the exynos4x12_set_apll() function, the APLL frequency is set
> >> > with direct register manipulation.
> >> >
> >> > Such approach is not allowed in the common clock framework. The
> >> > frequency is changed, but the corresponding clock value is not
> >> > updated. This causes wrong frequency read from cpufreq's
> >> > cpuinfo_cur_freq sysfs attribute.
> >> >
> >>
> >> This patch looks incomplete, leaving the driver in untidy state,
> >> perhaps its doesn't fix the above stated problem completely. what
> >> about if (!exynos4x12_pms_change(old_index, new_index)) becomes
> >> true?
> >>
> >> IMHO, this driver needs lot more work in addition to this patch to
> >> cleanly and completely move the cpufreq driver to common clock
> >> framework.
> >
> > I agree that the other case needs to be handled as well. Basically
> > the whole conditional block dependent on exynos4x12_pms_change()
> > can be safely dropped, because this condition is already handled in
> > PLL driver.
> >
> 
> Exactly!

After more corner case testing, I admit that corner cases with PLL s
parameter change are still broken (e.g. 1400000 -> 700000).

I will prepare v2 for it.

If I manage I will push it into -rc. If not those changes will be
included to exynos cpufreq rework. 

Thanks guys for a thorough review.

> 
> > Lukasz is already working on further rework of this driver to clean
> > it up from legacy code, but this will have to wait for 3.13, as
> > 3.12 is already in rc stage and only fixes can be accepted for it.
> >
> >> For fixing this issue urgently, setting CLK_GET_RATE_NOCACHE for
> >> apll in clk driver can also be quicker fix.
> >
> > Unfortunately this is not how this flag works. It only makes
> > clk_get_rate() call ->recalc_rate() operation of the clock instead
> > of instantly returning cached rate - it doesn't seem to work
> > recursively.
> >
> 
> hmm.. yes it can't help in our case as it recursively walks only the
> subtree of clk but in our case we are changing rate of parent.
> 
> Regards,
> Yadwinder



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
