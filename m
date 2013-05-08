Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab3EHCBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:01:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30698 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3EHCBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:01:04 -0400
X-Spam-Score: -100.8
Message-ID: <5189B1AE.4000906@asianux.com>
Date: Wed, 08 May 2013 10:00:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: tj@kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
References: <5188DB93.2080504@asianux.com> <5188DF27.4080000@huawei.com> <5188E391.6040505@asianux.com> <5189A166.9080301@huawei.com>
In-Reply-To: <5189A166.9080301@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年05月08日 08:50, Li Zefan wrote:
>>> There's a bug in cgroup_unload_subsys() that idr_destroy() should be called after
>>> >> ss->css_free(). That said, given there's no modular cgroup subsystem using css_id,
>>> >> and the whole css_id thing will be eliminated in 3.11, why bother fixing it.
>>> >>
>> > 
>> > I just find it by reading code (I also want to learn about kernel).
>> > 
>> > I guess, for some stable versions, may focus on it, they are the
>> > different branches from the latest version.
>> > 
>> > So, is it suitable to send related patch for the bug ?
>> > 
> As I said, there's no modular cgroup subsystem using css_id, so the bug
> doesn't exist in real world.
> 
> 
> 

Excuse me, my English is not quite well, I guess what you said is:

  a. idr_destroy() should be called after ss->css_free()
  b. need check the return value of cgroup_init_idr() in cgroup_init().

  but all features which related with the 2 issues above, never be used
in any main linux main branches.
  so, the 2 bugs doesn't exist in real world.

Is what I guess correct ?

Thanks.

-- 
Chen Gang

Asianux Corporation
