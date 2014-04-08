Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaDHF34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 01:29:56 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63909 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHF3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 01:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <53437D91.8070504@gmail.com>
References: <53429445.5000005@gmail.com>
	<CAKohpok189SxuJoGNvgshwEaUozMDM9mzA8wse5COkN8MBUaPg@mail.gmail.com>
	<53434A4E.2050407@gmail.com>
	<CAKohponSStjFJyKt7Yy7EX1wfk3xbJxoXpt47qStcSGfQVK7aw@mail.gmail.com>
	<53437D91.8070504@gmail.com>
Date: Tue, 8 Apr 2014 10:59:52 +0530
Message-ID: <CAKohpokFiuP0JFu0seOFL8PQXSE9dv+NxypKzRgUjq0wYMvw6g@mail.gmail.com>
Subject: Re: [PATCH] drivers:cpufreq:unicore32: fix typo issue for 'clk'
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2014 10:09, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> OK, I will/should try within this week, thanks.

Rafael has already applied this patch and has mentioned stable in
'Cc:' field. And it looks it will be applied automatically and you don't
need to do anything now :)


commit b4ddad95020e65cfbbf9aee63d3bcdf682794ade
Author: Chen Gang <gang.chen.5i5j@gmail.com>
Date:   Mon Apr 7 20:04:21 2014 +0800

    cpufreq: unicore32: fix typo issue for 'clk'

    Need use 'clk' instead of 'mclk', which is the original removed local
    variable.

    The related original commit:

      "652ed95 cpufreq: introduce cpufreq_generic_get() routine"

    The related error with allmodconfig for unicore32:

        CC      drivers/cpufreq/unicore2-cpufreq.o
      drivers/cpufreq/unicore2-cpufreq.c: In function 'ucv2_target':
      drivers/cpufreq/unicore2-cpufreq.c:48: error: 'struct
cpufreq_policy' has no member named 'mclk'
      make[2]: *** [drivers/cpufreq/unicore2-cpufreq.o] Error 1
      make[1]: *** [drivers/cpufreq] Error 2
      make: *** [drivers] Error 2

    Fixes: 652ed95d5fa6 (cpufreq: introduce cpufreq_generic_get() routine)
    Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
