Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaGIDHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaGIDHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:07:47 -0400
Message-ID: <53BCB1BE.7060301@redhat.com>
Date: Tue, 08 Jul 2014 23:06:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 02/12] sched: remove a wake_affine condition
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-3-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1404144343-18720-3-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/30/2014 12:05 PM, Vincent Guittot wrote:
> I have tried to understand the meaning of the condition : 
> (this_load <= load && this_load + target_load(prev_cpu, idx) <=
> tl_per_task) but i failed to find a use case that can take
> advantage of it and i haven't found clear description in the
> previous commits' log. Futhermore, the comment of the condition
> refers to the task_hot function that was used before being replaced
> by the current condition: /* * This domain has SD_WAKE_AFFINE and *
> p is cache cold in this domain, and * there is no bad imbalance. 
> */
> 
> If we look more deeply the below condition this_load +
> target_load(prev_cpu, idx) <= tl_per_task
> 
> When sync is clear, we have : tl_per_task = runnable_load_avg /
> nr_running this_load = max(runnable_load_avg, cpuload[idx]) 
> target_load =  max(runnable_load_avg', cpuload'[idx])
> 
> It implies that runnable_load_avg' == 0 and nr_running <= 1 in
> order to match the condition. This implies that runnable_load_avg
> == 0 too because of the condition: this_load <= load but if this
> _load is null, balanced is already set and the test is redundant.
> 
> If sync is set, it's not as straight forward as above (especially
> if cgroup are involved) but the policy should be similar as we have
> removed a task that's going to sleep in order to get a more
> accurate load and this_load values.
> 
> The current conclusion is that these additional condition don't
> give any benefit so we can remove them.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTvLG+AAoJEM553pKExN6DfhMH/iYJAS/nCq1teCNm39zZg1bF
MIp2iWwnB5VTQvwVLQ3FaGU80oWScUez8zjn26LjPp5SnxyDEwG0YVM3/57EyJme
PgffmP8xsVJwRkKnO4VRR0Go2EMXl9cdf9exe6lFjRyv4/Z15o9NZsDmX8JcLmG+
JPKq4DnMpJ3LiMiVuwwYtYSLk/tCHCPLnie4Z/WznlHk220WciVXFZG7AQI2AHXj
pMkZ5TWQODW7PEec+8dGzDnFcdXPftRYWCKLXG+9NM92YQpIsK8nZdC8rJeXhjBC
9VNb8QNZ6yVd0lvOSxy0drOV9BFXUImF6lsLxA12oHE6TLm6FeiHTG9X4xGOhN0=
=XlY9
-----END PGP SIGNATURE-----
