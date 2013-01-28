Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3A1Gro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:47:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31396 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3A1Grl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:47:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,550,1355068800"; 
   d="scan'208";a="6653522"
Message-ID: <51061F2F.6040104@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 14:48:15 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: serge.hallyn@canonical.com, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] userns: Allow the unprivileged users to mount mqueue
 fs
References: <1359342541-383-1-git-send-email-gaofeng@cn.fujitsu.com> <87bocayntu.fsf@xmission.com>
In-Reply-To: <87bocayntu.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 14:46:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 14:46:34,
	Serialize complete at 2013/01/28 14:46:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/01/28 11:43, Eric W. Biederman wrote:
> Gao feng <gaofeng@cn.fujitsu.com> writes:
> 
>> This patch allow the unprivileged user to mount mqueuefs in
>> user ns.
>>
>> If two userns share the same ipcns,the files in mqueue fs
>> should be seen in both these two userns.
>>
>> If the userns has its own ipcns,it has its own mqueue fs too.
>> ipcns has already done this job well.
> 
> I am a little dense.  When does userspace actually mount a mqueuefs?
> My impression was that user space never needed to mount and actually
> never could mount a mqueuefs.  MS_NO_USER isn't set so mounting a
> mqueuefs is possible but when does it happen and why?
> 

Actually the files which representative messgae queue in mqueuefs contains
some informations,such as QSIZE,NOTIFY,SIGNO,NOTIFY_PID.

My workstation is Fedora 17,mqueuefs is mounted on /dev/mqueue by default.
So I think at lest this patch is needed by some people.

Thanks!
Gao

> I am trying to think through the logic here and I think this is safe
> but since I don't understand why we would mount an mqueue fs I am
> having trouble verifying that there are no silly reasons why this might
> be a bad idea.
> 
> But from what I can tell so far this seems like a good patch.
> 
> Eric
> 
> 
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  ipc/mqueue.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
>> index 71a3ca1..023c986 100644
>> --- a/ipc/mqueue.c
>> +++ b/ipc/mqueue.c
>> @@ -1383,6 +1383,7 @@ static struct file_system_type mqueue_fs_type = {
>>  	.name = "mqueue",
>>  	.mount = mqueue_mount,
>>  	.kill_sb = kill_litter_super,
>> +	.fs_flags = FS_USERNS_MOUNT,
>>  };
>>  
>>  int mq_init_ns(struct ipc_namespace *ns)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

