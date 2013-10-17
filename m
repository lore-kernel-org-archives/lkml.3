Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3JQGcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:32:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52829 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3JQGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:32:43 -0400
X-AuditID: 85900ec0-d0927b9000001514-b3-525f84886b03
Message-ID: <525F8485.7090503@hitachi.com>
Date: Thu, 17 Oct 2013 15:32:37 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        aaronx.j.fabbri@intel.com
Subject: Re: Re: [PATCH V2 0/5] trace-cmd: Support the feature recording
 trace data of guests on the host
References: <20130913020627.28927.69090.stgit@yunodevel> <20131014172637.2ced6be9@gandalf.local.home>
In-Reply-To: <20131014172637.2ced6be9@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(2013/10/15 6:26), Steven Rostedt wrote:
> On Fri, 13 Sep 2013 11:06:27 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>
>> <How to use>
>> 1. Run virt-server on a host
>>     # trace-cmd virt-server
>>
>> 2. Make guest domain directory
>>     # mkdir -p /tmp/trace-cmd/virt/<domain>
>>     # chmod 710 /tmp/trace-cmd/virt/<domain>
>>     # chgrp qemu /tmp/trace-cmd/virt/<domain>
>
> Quick comment. I think the above should be done by trace-cmd. At least
> have options for it like:
>
> trace-cmd virt-server -d /tmp/trace-cmd/virt/domain -m 710 -g qemu
>
> Perhaps default some of those, and have trace-cmd print out:
>
>    Process Directory:     /tmp/trace-cmd/virt/domain
>    Directory permission:  0710
>    Group:                 qemu

OK. As you say, when we know domains which we will boot, trace-cmd
should make those automatically. So, I'll add this feature.
Note that if we don't know domains when we boot virt-sevrer, we must
make those manually now.

In this patch set, virt-server always uses /tmp/trace-cmd/virt, so
we had better indicate only the domain name with d option, I think.

trace-cmd virt-server -d domain -m 710 -g qemu

What do you think about this?

Thanks,

Yoshihiro YUNOMAE

> OK, now to look at the actual code ;-)
>
> -- Steve
>
>
>>
>> 3. Make FIFO on the host
>>     # mkfifo /tmp/trace-cmd/virt/<domain>/trace-path-cpu{0,1,...,X}.{in,out}
>>
>> 4. Set up of virtio-serial pipe of a guest on the host
>>     Add the following tags to domain XML files.
>>     # virsh edit <domain>
>>     <channel type='unix'>
>>        <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
>>        <target type='virtio' name='agent-ctl-path'/>
>>     </channel>
>>     <channel type='pipe'>
>>        <source path='/tmp/trace-cmd/virt/<domain>/trace-path-cpu0'/>
>>        <target type='virtio' name='trace-path-cpu0'/>
>>     </channel>
>>     ... (cpu1, cpu2, ...)
>>
>> 5. Boot the guest
>>     # virsh start <domain>
>>
>> 6. Execute "record --virt" on the guest
>>     # trace-cmd record --virt -e sched*
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


