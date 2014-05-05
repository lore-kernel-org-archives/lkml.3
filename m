Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaEEFyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:54:17 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49163 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaEEFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
Date: Mon, 5 May 2014 11:24:15 +0530
Message-ID: <CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2014 05:46, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> Hi. Viresh Kumar
> Your reply is so fast like Usain Bolt.

Heh, that's not true.. See how slow I was this time :)

>> So, create three flags:
>> OPP_TABLE_ORDER_ASCENDING              0
>> OPP_TABLE_ORDER_DESCENDING            1
>> OPP_TABLE_ORDER_ORIGINAL                  2 (And use this for your case.)
>
> -> Actually, I want to use OPP_TABLE_ORDER_DESCENDING.(Not
> OPP_TABLE_ORDER_ORIGINAL.)
> I think that it is enough to support both descending and ascending ordering
> only.
> The meaning of "ORIGIANL" Amit, said, when he(and I) writes a frequency in
> dts file with ordering(Ascending or Descending). He(and I) want the
> frequency to be register according to ordering.(Ascending or Descending).

But what if somebody doesn't have a ascending or descending list there? And
want to preserve the original list? That's why I recommended it.

> I concerned that if we use ORIGINAL ordering, opp_find_freq_ceil/foor can be
> broken.

I completely missed that earlier :) ..
It would be broken with descending one as well..

To skip the complexity of finding right freq associated with
"ORIGINAL" ordering,
lets concentrate on Ascending/Descending ordering for now.

So, this is what I would recommend now:
- Create two macros: OPP_TABLE_ORDER_ASCENDING and
  OPP_TABLE_ORDER_DESCENDING
- create of_init_opp_table_ordered(**, int order), order would be one of the
above two macros
- rename dev_pm_opp_add to __dev_pm_opp_add() and create a wrapper
over it: dev_pm_opp_add(), which would pass
OPP_TABLE_ORDER_ASCENDING to it by default and call it from
of_init_opp_table_ordered() like this: __dev_pm_opp_add(***, order)..

- Fix ceil/floor routines for these two cases.

--
viresh
