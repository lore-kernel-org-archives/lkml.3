Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaD2GKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:10:31 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56935 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaD2GKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <001301cf636e$f6032f70$e2098e50$@samsung.com>
References: <000601cf636b$3c2b39b0$b481ad10$@samsung.com>
	<CAOh2x=nzLNDe+vL5UvKkaRMDT7M+U9jG4HLHavS2ksmiOE_G+w@mail.gmail.com>
	<001301cf636e$f6032f70$e2098e50$@samsung.com>
Date: Tue, 29 Apr 2014 11:40:29 +0530
Message-ID: <CAKohpo=w61naPGUHqMaF2zUWsSuV_9Rb0rhj2uf0TPbNRe_gRA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM / OPP: Use list_for_each_entry_reverse instead of list_for_each_entry
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 11:20, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> -> You are right. But 5440 cpufreq driver write an index number instead of
> clk divider value
> for change DVFS. And our another(will submit) also write an index number for
> changing DVFS.
> As you said, order of table shouldn't matter at all in cpufreq layer. Then,
> could this can be applied?

These two patches aren't going to fly I believe. Depending on the order
of table for setting hardware is inviting trouble.

> In our case, We want to use index 0 for P0 and index 1 for P1.....

What I would recommend is, use .driver_data field to hold what has to
be written to hardware for any frequency. And then simply use
driver_data instead of index.
