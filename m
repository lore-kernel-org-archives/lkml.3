Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaIPVWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:22:51 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56759 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaIPVWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:22:50 -0400
MIME-Version: 1.0
In-Reply-To: <1410900696-6481-12-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410900696-6481-12-git-send-email-linux@rasmusvillemoes.dk>
Date: Tue, 16 Sep 2014 14:22:49 -0700
Message-ID: <CAKohpon9GjRb_Eimecss1aVXRCGJ+d=78ZFOOOfg8qCFyqumzw@mail.gmail.com>
Subject: Re: [PATCH 11/22] cpufreq: Replace strnicmp with strncasecmp
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2014 13:51, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
>
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.
>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/cpufreq/cpufreq.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Not really sure about the implementation of these routines but the
changes look fine.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

--
viresh
