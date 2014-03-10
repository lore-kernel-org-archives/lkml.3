Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaCJORZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:17:25 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51198 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaCJORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:17:24 -0400
Message-ID: <531DC971.6020208@gopivotal.com>
Date: Mon, 10 Mar 2014 14:17:21 +0000
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] control groups: documentation improvements
References: <20140310113928.GC18700@gnimac.gopivotal.com> <20140310140724.GA25290@htj.dyndns.org>
In-Reply-To: <20140310140724.GA25290@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

Thanks for your quick reply. Responses inline.

Regards,
Glyn

On 10/03/2014 14:07, Tejun Heo wrote:
> Hello, Glyn.
>
> On Mon, Mar 10, 2014 at 11:39:28AM +0000, Glyn Normington wrote:
>> Clarify that each hierarchy must be associated with at least one
>> subsystem.
> Hmmm... but named hierarchies can exist without any controllers
> attached to them.
Then we missed how to create a hierarchy with no associated subsystems. 
The only way I can think of is to use mount, specify no subsystems on -o 
(which defaults to all the subsystems defined in the kernel), and run it 
in a kernel with no subsystems defined (which seems unlikely these days).

Is that what you had in mind or is there some other way of creating a 
hierarchy with no subsystems attached?
>
>> Clarify that subsystems may be attached to multiple hierarchies,
>> although this isn't very useful, and explain what happens.
> And a subsystem may only be attached to a single hierarchy.
Perhaps that's what should happen, but the following experiment 
demonstrates a subsystem being attached to two hierarchies:

$ pwd
/home/vagrant
$ mkdir mem1
$ mkdir mem2
$ sudo su
# mount -t cgroup -o memory none /home/vagrant/mem1
# mount -t cgroup -o memory none /home/vagrant/mem2
# cd mem1
# mkdir inst1
# ls inst1
cgroup.clone_children  memory.failcnt ...
# ls ../mem2
cgroup.clone_children  inst1 memory.limit_in_bytes ...
# cd inst1
# echo 1000000 > memory.limit_in_bytes
# cat memory.limit_in_bytes
1003520
# cat ../../mem2/inst1/memory.limit_in_bytes
1003520
# echo $$ > tasks
# cat tasks
1365
1409
# cat ../../mem2/inst1/tasks
1365
1411
>
> Thanks.
>

