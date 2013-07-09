Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3GINPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:15:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:43082 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GINPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:15:19 -0400
Message-ID: <51DC0CE2.2050906@openvz.org>
Date: Tue, 09 Jul 2013 17:15:14 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
References: <20130708100046.14417.12932.stgit@zurg> <20130708170047.GA18600@mtj.dyndns.org> <20130708175201.GB9094@redhat.com> <20130708175607.GB18600@mtj.dyndns.org> <51DBC99F.4030301@openvz.org> <20130709125734.GA2478@htj.dyndns.org>
In-Reply-To: <20130709125734.GA2478@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
>
> On Tue, Jul 09, 2013 at 12:28:15PM +0400, Konstantin Khlebnikov wrote:
>> Yep, blkio has plenty problems and flaws and I don't get how it's related
>> to vfs layer, dirty set control and non-disk or network backed filesystems.
>> Any problem can be fixed by introducing new abstract layer, except too many
>> abstraction levels. Cgroup is pluggable subsystem, blkio has it's own plugins
>> and it's build on top of io scheduler plugin. All this stuff always have worked
>
> What does that have to do with anything?
>
>> with block devices. Now you suggest to handle all filesystems in this stack.
>> I think binding them to unrealated cgroup is rough leveling violation.
>
> How is blkio unrelated to filesystems mounted on block devices?
> You're suggesting a duplicate solution which can't be complete.

blkio controls block devices. not filesystems or superblocks or bdi or pagecache.
It's all about block layer and nothing more. Am I right?

So, you want to link some completely unrelated subsystems like NFS into the block layer?

>
>> NFS cannot be controlled only by network throttlers because we
>> cannot slow down writeback process when it happens, we must slow
>> down tasks who generates dirty memory.
>
> That's exactly the same problem why blkio doesn't work for async IOs
> right now, so if you're interested in the area, please contribute to
> fixing that problem.
>
>> Plus it's close to impossible to separate several workloads if they
>> share one NFS sb.
>
> Again, the same problem with blkio.  We need separate pressure
> channels on bdi for each cgroup.
>
> Thanks.
>

