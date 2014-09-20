Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaITTZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:25:44 -0400
Received: from forward9l.mail.yandex.net ([84.201.143.142]:59976 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbaITTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:25:43 -0400
X-Yandex-Uniq: d2566f1b-a347-4bd1-8456-9c1cfd8e20e1
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <541DD4B3.7080400@yandex.ru>
Date: Sat, 20 Sep 2014 23:25:39 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 3/7] sched: Use dl_bw_of() under RCU read lock
References: <20140920165116.16299.1381.stgit@localhost> <20140920165128.16299.20888.stgit@localhost> <20140920185705.GU2832@worktop.localdomain>
In-Reply-To: <20140920185705.GU2832@worktop.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.2014 22:57, Peter Zijlstra wrote:
> On Sat, Sep 20, 2014 at 08:51:28PM +0400, Kirill Tkhai wrote:
>> From: Kirill Tkhai <ktkhai@parallels.com>
>>
>> dl_bw_of() dereferences rq->rd which has to have RCU read lock held.
>> Probability of use-after-free and memory corruption aren't zero here.
>>
> 
> Additionally we might want to add something like:
> lockdep_assert_held_rcu() and put that in dl_bw_of() and other such
> places.

Should we change (not now, in general) RCU-related pointers to use
rcu_dereference() to have unlocked RCU warnings in dmesg? To catch
a problems like that.

This may make code worse readable though.

