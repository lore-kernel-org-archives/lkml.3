Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbaDIP6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:58:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38580 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934142AbaDIP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140409114116.31381178@gandalf.local.home>
References: <b1578f256ad2628baa9cf691dbe1cce20ff7757d.1397056966.git.viresh.kumar@linaro.org>
	<20140409114116.31381178@gandalf.local.home>
Date: Wed, 9 Apr 2014 21:28:31 +0530
Message-ID: <CAKohponUhM4kWPLRxSCoLt7pEWT8sjrMSiMU7TNiMFcQxjOSLg@mail.gmail.com>
Subject: Re: [PATCH] tick-sched: replace tick_nohz_active with
 tick_nohz_enabled in tick_nohz_switch_to_nohz()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        "# 3.13.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 21:11, Steven Rostedt <rostedt@goodmis.org> wrote:
> But tick_nohz_active also gets set by tick_setup_sched_timer() which
> looks to be where it should get set. What is the case that this would
> set that variable and tick_setup_sched_timer() would not?

These two are in parallel and only one of these will ever succeed. So,
either tick_setup_sched_timer() or tick_nohz_switch_to_nohz() will
set it.
