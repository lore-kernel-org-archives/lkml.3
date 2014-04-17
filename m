Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaDQIAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:00:14 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39641 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDQIAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:00:11 -0400
Message-ID: <534F8A0A.8030306@gopivotal.com>
Date: Thu, 17 Apr 2014 09:00:10 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
References: <533C0BB4.4070009@gopivotal.com> <20140402180019.GL16631@htj.dyndns.org> <534B982D.8060106@gopivotal.com> <20140414205034.GA6443@cmpxchg.org> <534CEFF2.7090207@gopivotal.com> <20140416091122.GC12866@dhcp22.suse.cz>
In-Reply-To: <20140416091122.GC12866@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/2014 10:11, Michal Hocko wrote:
> On Tue 15-04-14 09:38:10, Glyn Normington wrote:
>> On 14/04/2014 21:50, Johannes Weiner wrote:
>>> On Mon, Apr 14, 2014 at 09:11:25AM +0100, Glyn Normington wrote:
>>>> Johannes/Michal
>>>>
>>>> What are your thoughts on this matter? Do you see this as a valid
>>>> requirement?
>>> As Tejun said, memory cgroups *do* respond to internal pressure and
>>> enter targetted reclaim before invoking the OOM killer.  So I'm not
>>> exactly sure what you are asking.
>> We are repeatedly seeing a situation where a memory cgroup with a given
>> memory limit results in an application process in the cgroup being killed
>> oom during application initialisation. One theory is that dirty file cache
>> pages are not being written to disk to reduce memory consumption before the
>> oom killer is invoked. Should memory cgroups' response to internal pressure
>> include writing dirty file cache pages to disk?
> This depends on the kernel version. OOM with a lot of dirty pages on
> memcg LRUs was a big problem. Now we are waiting for pages under
> writeback during reclaim which should prevent from such spurious OOMs.
> Which kernel versions are we talking about? The fix (or better said
> workaround) I am thinking about is e62e384e9da8 memcg: prevent OOM with
> too many dirty pages.
Thanks Michal - very helpful!

The kernel version, as reported by uname -r, is 3.2.0-23-generic.

According to https://github.com/torvalds/linux/commit/e62e384e9da8, the 
above workaround first went into kernel version 3.6, so we should plan 
to upgrade.
>
> I am still not sure I understand your setup and the problem. Could you
> describe your setup (what runs where under what limits), please?
I won't waste your time with the details of our setup unless the problem 
recurs with e62e384e9da8 in place.

Regards,
Glyn

