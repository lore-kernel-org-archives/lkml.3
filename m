Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab3EXKHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:07:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760035Ab3EXKHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:07:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208";a="7355557"
Message-ID: <519F3B3F.2070809@cn.fujitsu.com>
Date: Fri, 24 May 2013 18:04:47 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Mell <sub.atomic.fusion@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
References: <3342521.NtikuogILA@pegasus> <24900395.sMN6olMGRM@pegasus> <519F2F65.4000400@cn.fujitsu.com> <1642748.MrLhTUgxmu@pegasus>
In-Reply-To: <1642748.MrLhTUgxmu@pegasus>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 18:05:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 18:05:47,
	Serialize complete at 2013/05/24 18:05:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 05:35 PM, Stephen Mell wrote:

> On Friday, May 24, 2013 17:14:13 Gu Zheng wrote:
> 
>> One fuzzy way in my mind, I'm not sure whether it's OK, but we can discuss it.
>> Split hide_pid, pid_gid, and proc_self from pid_namespace, and create struct proc_sb_info(maybe the name "proc_mount_info" is better). 
>> And create a new list domain in the pid_namespace to contain the proc_sb_info instances. Each time we mount proc in a new directory only
>> create a new proc_sb_info instance, and added it to the list in pid_namespace. 
>> But this leads to another problem, how to get the right proc_sb_info instance in proc permission checking routine, do you have any idea?
>> what do you think of this way?
> 
> I understand now what you're getting at.
> However, I'd like to make the argument that it is desirable to have each proc mount, even those that reference the same namespace, have a different superblock. One option that I intend to add is the ability to specify which pid namespace proc is mounted for, rather than forcing the current one. If this were to be added, it wouldn't work to share superblocks, as that would prevent remounts of proc from switching which namespace that the refer to (or that is my understanding, which may be incorrect).
> Considering the small number of proc mounts that tend to be around anyway, perhaps this outweighs the drawbacks.
> Let me know what you think.


It doesn't matter, if we can not find a better way, the current one is best, go ahead!:)

Thanks,
Gu

> 
>> Thanks,
>> Gu
> 
> Thanks,
> Stephen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


