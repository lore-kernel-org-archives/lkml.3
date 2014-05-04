Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaEDGCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:02:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20022 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaEDGCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:02:31 -0400
Message-ID: <5365D7EF.7050802@huawei.com>
Date: Sun, 4 May 2014 14:02:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hannes@cmpxchg.org>, <mhocko@suse.cz>, <nasa4836@gmail.com>
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert css_from_id()
 to use it
References: <1398373333-1521-1-git-send-email-tj@kernel.org> <1398373333-1521-7-git-send-email-tj@kernel.org> <535DCBFC.4000404@huawei.com> <20140501154630.GG31611@htj.dyndns.org>
In-Reply-To: <20140501154630.GG31611@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Just came back from a short vacation)

On 2014/5/1 23:46, Tejun Heo wrote:
> On Mon, Apr 28, 2014 at 11:33:16AM +0800, Li Zefan wrote:
>> On 2014/4/25 5:02, Tejun Heo wrote:
>>> Until now, cgroup->id has been used to identify all the associated
>>> csses and css_from_id() takes cgroup ID and returns the matching css
>>> by looking up the cgroup and then dereferencing the css associated
>>> with it; however, now that the lifetimes of cgroup and css are
>>> separate, this is incorrect and breaks on the unified hierarchy when a
>>> controller is disabled and enabled back again before the previous
>>> instance is released.
>>>
>>> This patch adds css->id which is a subsystem-unique ID and converts
>>> css_from_id() to look up by the new css->id instead.  memcg is the
>>> only user of css_from_id() and also converted to use css->id instead.
>>>
>>
>> netprio_cgroup also needs to be updated.
> 
> Why?  Wouldn't it be more natural to tie that to the associated
> cgroup's ID rather than the specific css instance.  It's different for
> memcg as it involves css refcnts but netprio_cgroup, AFAICS, only uses
> it for cgroup identification anyway.
> 

You're right. I thought it won't work correctly in unified hierarchy
where controllers can be disabled/enabled.

