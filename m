Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3KGSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:45:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57493 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750940Ab3KGSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:45:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
Date: Thu, 07 Nov 2013 19:57:41 +0100
Message-ID: <4433736.xh14GOaN7a@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com> <CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 07, 2013 10:39:38 AM Viresh Kumar wrote:
> On 7 November 2013 07:58, Xiaoguang Chen <chenxg@marvell.com> wrote:
> > When decreasing frequency, requested_freq may be less than
> > freq_target, So requested_freq minus freq_target may be negative,
> > But reqested_freq's unit is unsigned int, then the negative result
> > will be one larger interger which may be even higher than
> > requested_freq.
> >
> > This patch is to fix such issue. when result becomes negative,
> > set requested_freq as the min value of policy.
> >
> > Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> > ---
> >  drivers/cpufreq/cpufreq_conservative.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Good Catch.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied, thanks!

> We need another patch for fixing the other part of code where we
> increase freq..
> We need to replace:
> 
> if (dbs_info->requested_freq == policy->max)
>     return;
> 
> with
> 
> if (dbs_info->requested_freq >= policy->max)
>     return;
> 
> So, that we don't run unnecessary code :)

Care to prepare a patch?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
