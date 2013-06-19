Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935346Ab3FSWl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:41:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43383 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935028Ab3FSWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:41:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Xiaoguang Chen <chenxg@marvell.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
Date: Thu, 20 Jun 2013 00:50:44 +0200
Message-ID: <10398431.HfgFiK9AG8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAFgnuDdN6CoLCvH6-d9YB=-jm-ESC1s__si970pa10mC3wsCdw@mail.gmail.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com> <CAKohpokN_iJ5in0t3Mo68Tost0u2WT65PQtynQ7-wxGZr0LDQQ@mail.gmail.com> <CAFgnuDdN6CoLCvH6-d9YB=-jm-ESC1s__si970pa10mC3wsCdw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 11:26:13 AM Xiaoguang Chen wrote:
> 2013/6/19 Viresh Kumar <viresh.kumar@linaro.org>:
> > On 19 June 2013 08:43, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> On 19 June 2013 06:50, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> >>> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >>
> >>>>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
> >>>>
> >>>> Can you please tell me what the above is supposed to mean?  Is it supposed to
> >>>> mean "the online of cpu3 is being run on cpu0" or something different?  If
> >>>> something different, then what?
> 
> Sorry I missed this question, Let me explain it in detail
> Suppose we are in such condtition, current cpufreq goveror is
> userspace governor. cpu3 is offline.
> and two things happen as above two cases, first thing is application
> tries to change current governor to ondemand governor,
> second thing is cpu0 tries to make cpu3 online which is off line
> before. both of these two cases will try to stop current governor and
> start a governor. if above two things interleave, unexpected behavior
> will happen.

Now it's clear, thanks for the explanation.  [Well, I'll still need to fix up
the changelog.  Sigh.]

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
