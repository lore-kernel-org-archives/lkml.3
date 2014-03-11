Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaCKDAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:00:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59534 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbaCKDAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:00:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,628,1389715200"; 
   d="scan'208";a="9675743"
Message-ID: <531E765C.7060102@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 10:35:08 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] kernel/sys: Replace hardcoding of 20 with MAX_NICE +
 1
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>  <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com>  <1394490222.21085.16.camel@joe-AO722> <531E6416.6020106@cn.fujitsu.com> <1394504465.21085.27.camel@joe-AO722>
In-Reply-To: <1394504465.21085.27.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 10:34:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 10:35:14,
	Serialize complete at 2014/03/11 10:35:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 10:21 AM, Joe Perches wrote:
> On Tue, 2014-03-11 at 09:17 +0800, Dongsheng Yang wrote:
>> Hi Joe,
>>
>> On 03/11/2014 06:23 AM, Joe Perches wrote:
>>> Convert the use of 20 to NICE_MAX + 1.
>> What about adding a macro in prio.h to convert nice value [19,-20] to
>> rlimit
>> style value [1,40]?
>>
>> It seems that it will be used in several places.
> Fine by me.  knock yourself out.
>
> You might also consider changing these:

Yeah, my original plan is changing them from kernel/* to include/* then
to other subsystem such as driver, as I think I need to send them to 
different
ML and different maintainers. But I think it is time to complete it now,
and we should make these changes go into tip tree.

So I will send a patch set for them.

- Dongsheng
>
> $ git grep -n -w -E "19|20"|grep -P "_nice" -i
> drivers/block/loop.c:551:	set_user_nice(current, -20);
> drivers/block/nbd.c:536:	set_user_nice(current, -20);
> drivers/block/pktcdvd.c:1466:	set_user_nice(current, -20);
> drivers/char/ipmi/ipmi_si_intf.c:1001:	set_user_nice(current, 19);
> drivers/s390/crypto/ap_bus.c:1806:	set_user_nice(current, 19);
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:467:	set_user_nice(current, -20);
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:605:	set_user_nice(current, -20);
> drivers/scsi/bnx2i/bnx2i_hwi.c:1873:	set_user_nice(current, -20);
> drivers/scsi/fcoe/fcoe.c:1875:	set_user_nice(current, -20);
> drivers/scsi/ibmvscsi/ibmvfc.c:4518:	set_user_nice(current, -20);
> drivers/scsi/ibmvscsi/ibmvscsi.c:2216:	set_user_nice(current, -20);
> drivers/scsi/lpfc/lpfc_hbadisc.c:736:	set_user_nice(current, -20);
> drivers/scsi/qla2xxx/qla_os.c:4759:	set_user_nice(current, -20);
> drivers/staging/android/binder.c:439:	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
> drivers/staging/android/binder.c:444:	if (min_nice < 20)
> drivers/staging/lustre/lustre/llite/lloop.c:410:	set_user_nice(current, -20);
> fs/ocfs2/cluster/heartbeat.c:1110:	set_user_nice(current, -20);
> include/linux/ioprio.h:55:	return (task_nice(task) + 20) / 5;
> include/linux/sched/prio.h:4:#define MAX_NICE	19
> include/linux/sched/prio.h:5:#define MIN_NICE	-20
> kernel/locking/locktorture.c:219:	set_user_nice(current, 19);
> kernel/sys.c:253:				niceval = 20 - task_nice(p);
> kernel/sys.c:264:				niceval = 20 - task_nice(p);
> kernel/sys.c:280:					niceval = 20 - task_nice(p);
> kernel/workqueue.c:105:	RESCUER_NICE_LEVEL	= -20,
> kernel/workqueue.c:106:	HIGHPRI_NICE_LEVEL	= -20,
> tools/testing/selftests/mqueue/mq_perf_tests.c:532:	cur_nice = -20;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

