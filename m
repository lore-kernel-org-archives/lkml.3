Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3LFSCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:02:36 -0500
Received: from relay.parallels.com ([195.214.232.42]:32883 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3LFSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:02:35 -0500
Message-ID: <52A21136.9090605@parallels.com>
Date: Fri, 6 Dec 2013 22:02:30 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org> <52A1766F.5090808@parallels.com> <20131206161312.GC13373@htj.dyndns.org>
In-Reply-To: <20131206161312.GC13373@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 08:13 PM, Tejun Heo wrote:
> Hello, Vladimir.
>
> On Fri, Dec 06, 2013 at 11:02:07AM +0400, Vladimir Davydov wrote:
>> This patch fixes this bug, but I have a couple of questions regarding it.
>>
>> First, cgroup_load_subsys() also calls css_online(), and if it fails, it
>> calls cgroup_unload_subsys() to rollback. The latter function executes
>> the following command:
>>
>>     offline_css(cgroup_css(cgroup_dummy_top, ss));
>>
>> But since we failed to online_css(), cgroup_css() will return NULL
>> resulting in another oops.
> I don't think the root css onlining fails for any existing controllers
> but yeah that looks wrong.  Can you please send a patch?

Sure, I will send it soon.

Thanks.
