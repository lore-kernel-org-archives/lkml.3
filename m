Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3FMFkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:40:20 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51971 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3FMFkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
References: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
	<CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
Date: Thu, 13 Jun 2013 13:40:16 +0800
Message-ID: <CAFgnuDeeU5qALyqN4Akpi5SoHRXPWaq_PLYSSmjxkq9V5N=qag@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: fix governor start/stop race condition
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/12 Viresh Kumar <viresh.kumar@linaro.org>:
> On 12 June 2013 14:39, Xiaoguang Chen <chenxg@marvell.com> wrote:
>
>>         ret = policy->governor->governor(policy, event);
>
> We again reached to the same problem. We shouldn't call
> this between taking locks, otherwise recursive locks problems
> would be seen again.

But this is not the same lock as the deadlock case, it is a new lock,
and only used in this function. no other functions use this lock.
I don't know how can we get dead lock again?

Thanks
Xiaoguang
