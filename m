Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaFEP4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:56:00 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaFEPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:55:58 -0400
Message-ID: <5390930A.8050504@nod.at>
Date: Thu, 05 Jun 2014 17:55:54 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org,
        handai.szj@taobao.com, rientjes@google.com, oleg@redhat.com,
        rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605150025.GB15939@dhcp22.suse.cz>
In-Reply-To: <20140605150025.GB15939@dhcp22.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.06.2014 17:00, schrieb Michal Hocko:
> On Thu 05-06-14 16:00:41, Richard Weinberger wrote:
>> Don't spam the kernel logs if the oom_control event fd has listeners.
>> In this case there is no need to print that much lines as user space
>> will anyway notice that the memory cgroup has reached its limit.
> 
> But how do you debug why it is reaching the limit and why a particular
> process has been killed?

In my case it's always because customer's Java application gone nuts.
So I don't really have to debug a lot. ;-)
But I can understand your point.

> If we are printing too much then OK, let's remove those parts which are
> not that useful but hiding information which tells us more about the oom
> decision doesn't sound right to me.

What about adding a sysctl like "vm.oom_verbose"?
By default it would be 1.
If set to 0 the full OOM information is only printed out if nobody listens
to the event fd.

Thanks,
//richard
