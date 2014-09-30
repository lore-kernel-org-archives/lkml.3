Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaI3V67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbaI3V64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:58:56 -0400
Message-ID: <542B277D.7050103@redhat.com>
Date: Tue, 30 Sep 2014 17:58:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/2] sched/fair: leverage the idle state info when
 choosing the "idlest" cpu
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/04/2014 11:32 AM, Nicolas Pitre wrote:
> The code in find_idlest_cpu() looks for the CPU with the smallest
> load. However, if multiple CPUs are idle, the first idle CPU is
> selected irrespective of the depth of its idle state.
> 
> Among the idle CPUs we should pick the one with with the shallowest
> idle state, or the latest to have gone idle if all idle CPUs are in
> the same state.  The later applies even when cpuidle is configured
> out.
> 
> This patch doesn't cover the following issues:

The main thing it does not cover is already running tasks that
get woken up again, since select_idle_sibling() covers everything
except for newly forked and newly executed tasks.

I am looking at adding similar logic to select_idle_sibling()

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUKyd9AAoJEM553pKExN6DXZgH/1R26XfYv2FzYV9IGbty3vVx
1kMPozdb7jRAUR8+WkUgs7ntkbqau2hC/nTjDsSsiLQwXdjaDdqvnbt8Y6srI1es
/Z+IRaIPGx24D7D6nB5sLgsAq6DsANUdtFK3TsED8+07LbiY71o64YQ3X1IEVyRO
FKBcDw9+DBPGVySKIdMm0h2txdnQ3Jy2lM3nKV8tBFheRuOhU4Rv/fumEYAUYvDV
J9y91RhKOeEJYmaYL6oQYtZgBqhDoJmh/0DjOrK6H71oZYiNWeIUxtieNXaNQp7B
Rd8khOVFLsf/qZK6qjmgnfO9Mm5ij/PvrALOBZt8O9KAD3/v3kXfWIm9tO1NDZU=
=kTdn
-----END PGP SIGNATURE-----
