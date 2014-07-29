Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaG2RFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaG2RFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:05:05 -0400
Message-ID: <53D7D412.4040203@redhat.com>
Date: Tue, 29 Jul 2014 13:04:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
References: <1406571388-3227-1-git-send-email-riel@redhat.com> <1406571388-3227-2-git-send-email-riel@redhat.com> <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com> <20140729145910.GH3935@laptop> <53D7BAA5.8080404@redhat.com> <20140729154956.GJ3935@laptop>
In-Reply-To: <20140729154956.GJ3935@laptop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/29/2014 11:49 AM, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 11:15:49AM -0400, Rik van Riel wrote:
> 
>>> Right, so we want that code for overloaded -> overloaded
>>> migrations such as not to cause idle cpus in an attempt to
>>> balance things. Idle cpus are worse than imbalance.
>>> 
>>> But in case of overloaded/imb -> !overloaded migrations we can 
>>> allow it, and in fact want to allow it in order to balance
>>> idle cpus.
>> 
>> In case the destination is over the average load, or the source
>> is under the average load, fix_small_imbalance() determines
>> env->imbalance.
>> 
>> The "load_above_capacity" calculation is only reached when
>> busiest is busier than average, and the destination is under the
>> average load. In that case, env->imbalance ends up as the minimum
>> of busiest - avg and avg - target.
>> 
>> Is there any case where limiting it further to "load - capacity"
>> from the busiest domain makes a difference?
> 
> sadly yes; suppose 8 cpus in 2 groups and 9 tasks, 8 tasks of
> weight 10, 1 of 1024. The local group will have 5 tasks of 10, the
> busiest will have the remaining 4.

Good point!

Looks like your patches address all issues raised, and the code
looks nicer than before.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT19QSAAoJEM553pKExN6DM+EH/A0VSAcLB5TIDOC9axBwxdtY
RxDkYvGZJ9OvbsU83alpjm+ee5l1x+A1tKQofqd1QVDSfpq9QPrUniueeqnNyJhM
/alIRP/09bmH8vdn0uTqVrrx/lESeNPop5KmWimAdm1s452Lz8iuU3KmZryGssyJ
MolSWGKwNbWIncBLRtkNB7szlkLyvO0JZQN5FnA1xrzDZeaCA9j072t/49fiscbs
t6O8LxxsyooM+Wj3KyNt5dSKb9kHKf9gg0Z1dwcEqpcBjTB1jZNwOLQfhhaXX4gX
Gu55x8bJzFRMLey1EVtzlM7gnjpgiELbyfB7JibN0I8pYJKS9EcybCjQuq7BuvA=
=dt7v
-----END PGP SIGNATURE-----
