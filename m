Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3JUWyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:54:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55933 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752128Ab3JUWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:54:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "open list:CPU FREQUENCY DRI..." <cpufreq@vger.kernel.org>,
        "open list:CPU FREQUENCY DRI..." <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: fix possible integer overflow
Date: Tue, 22 Oct 2013 01:06:02 +0200
Message-ID: <7950903.3bCg8Tn2fH@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5265AE27.90600@gmail.com>
References: <1382239876-12688-1-git-send-email-geyslan@gmail.com> <1734089.XZ0ga7sQd1@vostro.rjw.lan> <5265AE27.90600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 21, 2013 03:43:51 PM Dirk Brandewie wrote:
> On 10/21/2013 03:47 PM, Rafael J. Wysocki wrote:
> > On Monday, October 21, 2013 08:56:22 AM Dirk Brandewie wrote:
> >> On 10/19/2013 08:31 PM, Geyslan G. Bem wrote:
> >>> The expression 'pstate << 8' is evaluated using 32-bit arithmetic while
> >>> 'val' expects an expression of type u64.
> >>>
> >>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> >> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> >
> > Actually, isn't (pstate << 8) guaranteed not to overflow?
> >
> 
> Yes, I was assuming this was caught by a static checking tool.

What was caught by the tool was the fact that 1UL << 32 might overflow on
32-bit, so using BIT(32) wasn't correct.

> I didn't see a downside to giving the compilier complete information.

Well, in that case the function's argument should be u64 rather than int.

Either you know that it won't overflow, in which case the explicit type
casting doesn't change anything, or you are not sure, in which case it's
better to use u64 as the original type anyway in my opinion.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
