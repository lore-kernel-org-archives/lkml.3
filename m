Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3EHAvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:51:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44199 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3EHAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:51:14 -0400
Message-ID: <5189A166.9080301@huawei.com>
Date: Wed, 8 May 2013 08:50:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
References: <5188DB93.2080504@asianux.com> <5188DF27.4080000@huawei.com> <5188E391.6040505@asianux.com>
In-Reply-To: <5188E391.6040505@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There's a bug in cgroup_unload_subsys() that idr_destroy() should be called after
>> ss->css_free(). That said, given there's no modular cgroup subsystem using css_id,
>> and the whole css_id thing will be eliminated in 3.11, why bother fixing it.
>>
> 
> I just find it by reading code (I also want to learn about kernel).
> 
> I guess, for some stable versions, may focus on it, they are the
> different branches from the latest version.
> 
> So, is it suitable to send related patch for the bug ?
> 

As I said, there's no modular cgroup subsystem using css_id, so the bug
doesn't exist in real world.

