Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256AbaGXHEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:04:49 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51564 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGXHEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:04:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rafael David Tinoco <rafael.tinoco@canonical.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
	<87ioo7vy5s.fsf@x220.int.ebiederm.org>
	<20140611234902.GQ4581@linux.vnet.ibm.com>
	<87bntzt24g.fsf@x220.int.ebiederm.org>
	<CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
	<874mzrszlk.fsf@x220.int.ebiederm.org>
	<CAJE_dJzShXxjsywRo_kwa0ez6Seu7+dModbz2Lvha5iuJw7FTw@mail.gmail.com>
	<CAJE_dJzjcWP=e_CPM1M64URVHiEFFb+fP6g2YKZVdoFntkQMZg@mail.gmail.com>
	<87wqckqrxe.fsf@x220.int.ebiederm.org>
	<CAJE_dJyaxDiR3zY0KdUgoFyv8SiMTOfMMZOP0JH6je_wC_=mBQ@mail.gmail.com>
	<73833A09-DF3C-49CE-8F78-91A822651F75@canonical.com>
Date: Thu, 24 Jul 2014 00:01:02 -0700
In-Reply-To: <73833A09-DF3C-49CE-8F78-91A822651F75@canonical.com> (Rafael
	David Tinoco's message of "Thu, 17 Jul 2014 09:05:01 -0300")
Message-ID: <87egxbkzpt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18nI1qarQYHgSTasxzav2CXt92qFFaNwVg=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4932]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Rafael David Tinoco <rafael.tinoco@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael David Tinoco <rafael.tinoco@canonical.com> writes:

> Hello Eric,
>
> Coming back to this...
>
> On Jun 16, 2014, at 12:01 PM, Rafael Tinoco <rafael.tinoco@canonical.com> wrote:
>
>> ...
>> 
>> On Fri, Jun 13, 2014 at 9:02 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Rafael Tinoco <rafael.tinoco@canonical.com> writes:
>>> 
>>>> Okay,
>>>> 
>>>> Tests with the same script were done.
>>>> I'm comparing : master + patch vs 3.15.0-rc5 (last sync'ed rcu commit)
>>>> and 3.9 last bisect good.
>>>> 
>>>> Same tests were made. I'm comparing the following versions:
>>>> 
>>>> 1) master + suggested patch
>>>> 2) 3.15.0-rc5 (last rcu commit in my clone)
>>>> 3) 3.9-rc2 (last bisect good)
>>> 
>>> I am having a hard time making sense of your numbers.
>>> 
>>> If I have read your email correctly my suggested patch caused:
>>> "ip netns add" numbers to improve
>>> 1x "ip netns exec" to improve some
>>> 2x "ip netns exec" to show no improvement
>>> "ip link add" to show no effect (after the 2x ip netns exec)
>> 
>> - "netns add" are as good as they were before this regression.
>> - "netns exec" are improved but still 50% of the last good bisect commit.
>> - "link add" didn't show difference.
>> 
>>> This is interesting in a lot of ways.
>>> - This seems to confirm that the only rcu usage in ip netns add
>>>  was switch_task_namespaces.  Which is convinient as that rules
>>>  out most of the network stack when looking for performance oddities.
>>> 
>>> - "ip netns exec" had an expected performance improvement
>>> - "ip netns exec" is still slow (so something odd is still going on)
>>> - "ip link add" appears immaterial to the performance problem.
>>> 
>>> It would be interesting to switch the "ip link add" and "ip netns exec"
>>> in your test case to confirm that there is nothing interesting/slow
>>> going on in "ip link add"
>> 
>> - will do that.
>
> IP link add seems ok.
>
>> 
>>> 
>>> Which leaves me with the question what ip "ip netns exec" remains
>>> that is using rcu and is slowing all of this down.
>> 
>> - will check this also.
>
> Based on my tests (and some other users that deployed this patch on a server farm)
> it looks like changing rcu_read_lock() to task_lock() did the trick. We are getting
> same (sometimes much better) results - comparing bisect good - for a big amount 
> of netns being created simultaneously. 
>
> Is it possible to make this change permanent in kernel tree ? 

Definitely.  I just need to finish getting my act together.

It sounded like you had seen other performance problems and I was
waiting on your futher testing so we could narrow down.

If you can't see other problems then I am happy to move forward with
this.

Thank you for testing and reporting this,

Eric
