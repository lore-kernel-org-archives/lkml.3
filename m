Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3GPK67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:58:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58242 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3GPK65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:58:57 -0400
X-AuditID: cbfee61b-b7f1f6d000000f14-df-51e5276f0f45
Date: Tue, 16 Jul 2013 12:58:48 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Message-id: <20130716125848.770ba264@amdc308.digital.local>
In-reply-to: <CAKohpokiF8ZamE_=XdPrjZQ8VHQ9wvzQy6w+6byO-T7J9c=6mA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-5-git-send-email-l.majewski@samsung.com>
 <CAKohpokiF8ZamE_=XdPrjZQ8VHQ9wvzQy6w+6byO-T7J9c=6mA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoG6++tNAg73flSz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	roy1296zFTznqejbu569gbGTq4uRg0NCwERi6VzNLkZOIFNM4sK99WxdjFwcQgLTGSXOzL3B
	BOG0M0m82HaOFaSKRUBVovlZCxuIzSagJ/H57lMmkEEiAloSL2+mgtQzC3xklrh78DYLSI2w
	QIrE7c5FTCA2r4C1xP8b7ewgNqdAsMS/7eugFrQALfhwlBEkwS8gKdH+7wczxEl2Euc+bWCH
	aBaU+DH5HthQZqBlm7c1sULY8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERxJz6R3MK5qsDjEKMDBqMTDe5DzSaAQa2JZcWXuIUYJDmYlEd5b/E8D
	hXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTAyO+6/o5p2
	69yvSs159w7982HxFtx37p9ekscL0wcLZv95ImbcHm+kcXyHmE90dal9PXPJJ47FusonElLy
	a022BfYu4L+QM1n70q1J18v0q5+dTjiSpZP+W6TeZ8ZsxznuPLev9DzoDrgtXGU1j8dutphC
	8sE37DfvaDr4pRdphU1rs/R6l6/EUpyRaKjFXFScCAAqidi0oAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:18:57 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > The struct cpufreq_driver has been extended to embrace the
> > information related to boost support.
> >
> > When "boost_mode" device tree attribute is defined for a platform,
> > the boost_supported flag is set. Moreover boost related attributes
> > were exported.
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> 
> Don't we need to mark any frequencies in the freq table with BOOST?
> How?

The (trivial) patch is already prepared to enable BOOST at cpufreq for
Exynos4412. I will post it for v6. Sorry for not posting it earlier.

The whole patch is as follow:

static struct clk *cpu_clk;
static struct clk *mout_core;
static struct clk *sclk_mpll;
static struct clk *mout_apll;
 
static unsigned int exynos4x12_volt_table[] = {
	1350000, 1287500, 1250000, 1187500, 1137500, 1087500, 1037500,
 	1000000,  987500,  975000,  950000,  925000,  900000,  900000
};
 
 static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
-	{L0, CPUFREQ_ENTRY_INVALID},
+	{CPUFREQ_BOOST_FREQ, 1500 * 1000},
 	{L1, 1400 * 1000},
 	{L2, 1300 * 1000},
 	{L3, 1200 * 1000},
 	{L4, 1100 * 1000},
 	{L5, 1000 * 1000},
 	{L6,  900 * 1000},
 	{L7,  800 * 1000},
 	{L8,  700 * 1000},
 	{L9,  600 * 1000},
 	{L10, 500 * 1000},
 	{L11, 400 * 1000},
 	{L12, 300 * 1000},



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
