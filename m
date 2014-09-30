Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaI3KIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaI3KIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:08:39 -0400
Message-ID: <542A80F4.7020704@redhat.com>
Date: Tue, 30 Sep 2014 06:07:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org
CC: linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] sched: fix spurious active migration
References: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/30/2014 04:41 AM, Vincent Guittot wrote:
> Since commit caeb178c60f4 ("sched/fair: Make
> update_sd_pick_busiest() ...") sd_pick_busiest returns a group that
> can be neither imbalanced nor overloaded but is only more loaded
> than others. This change has been introduced to ensure a better
> load balance in system that are not overloaded but as a side
> effect, it can also generate useless active migration between
> groups.
> 
> Let take the example of 3 tasks on a quad cores system. We will
> always have an idle core so the load balance will find a busiest
> group (core) whenever an ILB is triggered and it will force an
> active migration (once above nr_balance_failed threshold) so the
> idle core becomes busy but another core will become idle. With the
> next ILB, the freshly idle core will try to pull the task of a busy
> CPU. The number of spurious active migration is not so huge in quad
> core system because the ILB is not triggered so much. But it
> becomes significant as soon as you have more than one sched_domain
> level like on a dual cluster of quad cores where the ILB is
> triggered every tick when you have more than 1 busy_cpu
> 
> We need to ensure that the migration generate a real improveùent
> and will not only move the avg_load imbalance on another CPU.

Good catch.

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUKoD0AAoJEM553pKExN6DD4UIAIDM2q15MMhgKOEhKzFJfBod
XXeP5ouzeyRYwBomZhQazBqX42YOQ9YsYwydYJNacUcCP41DTNElvwOY6/l6znHK
GqYQFPxEtoi1e42EHvqQUVeISjKk1RFWpf4kQI8qhq1lYClWakn6ATk5RzbImYTR
MxjDL3WOXkywo9+lksF+N4TjpuBRDA5YKGvjSozeGMJFZyMzBsBNQDfDbv6ccHx3
uTPVi+3UXbVuTVsa5imHayxFL1+aEBMhBd2Y3mdQdKwds3SCHxrU+3v3o4wAm8qI
AD6l/QTmPnwUKCeZod9fXZLApFFIO5aQgQBCEj3M2Sz9HtsbQjJoxL3gybbUBug=
=ja1y
-----END PGP SIGNATURE-----
