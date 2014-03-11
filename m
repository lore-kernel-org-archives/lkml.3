Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaCKCVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:21:20 -0400
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:35896 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754374AbaCKCVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:21:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3873:3874:4321:5007:7652:7875:7903:8527:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hate20_43f605e43440c
X-Filterd-Recvd-Size: 3201
Message-ID: <1394504465.21085.27.camel@joe-AO722>
Subject: Re: [PATCH] kernel/sys: Replace hardcoding of 20 with MAX_NICE + 1
From: Joe Perches <joe@perches.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com
Date: Mon, 10 Mar 2014 19:21:05 -0700
In-Reply-To: <531E6416.6020106@cn.fujitsu.com>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <1d7cbeaa53561339ddf3b987fce6a7302d7405a3.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <1394490222.21085.16.camel@joe-AO722> <531E6416.6020106@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 09:17 +0800, Dongsheng Yang wrote:
> Hi Joe,
> 
> On 03/11/2014 06:23 AM, Joe Perches wrote:
> > Convert the use of 20 to NICE_MAX + 1.
> 
> What about adding a macro in prio.h to convert nice value [19,-20] to 
> rlimit
> style value [1,40]?
> 
> It seems that it will be used in several places.

Fine by me.  knock yourself out.

You might also consider changing these:

$ git grep -n -w -E "19|20"|grep -P "_nice" -i
drivers/block/loop.c:551:	set_user_nice(current, -20);
drivers/block/nbd.c:536:	set_user_nice(current, -20);
drivers/block/pktcdvd.c:1466:	set_user_nice(current, -20);
drivers/char/ipmi/ipmi_si_intf.c:1001:	set_user_nice(current, 19);
drivers/s390/crypto/ap_bus.c:1806:	set_user_nice(current, 19);
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:467:	set_user_nice(current, -20);
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:605:	set_user_nice(current, -20);
drivers/scsi/bnx2i/bnx2i_hwi.c:1873:	set_user_nice(current, -20);
drivers/scsi/fcoe/fcoe.c:1875:	set_user_nice(current, -20);
drivers/scsi/ibmvscsi/ibmvfc.c:4518:	set_user_nice(current, -20);
drivers/scsi/ibmvscsi/ibmvscsi.c:2216:	set_user_nice(current, -20);
drivers/scsi/lpfc/lpfc_hbadisc.c:736:	set_user_nice(current, -20);
drivers/scsi/qla2xxx/qla_os.c:4759:	set_user_nice(current, -20);
drivers/staging/android/binder.c:439:	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
drivers/staging/android/binder.c:444:	if (min_nice < 20)
drivers/staging/lustre/lustre/llite/lloop.c:410:	set_user_nice(current, -20);
fs/ocfs2/cluster/heartbeat.c:1110:	set_user_nice(current, -20);
include/linux/ioprio.h:55:	return (task_nice(task) + 20) / 5;
include/linux/sched/prio.h:4:#define MAX_NICE	19
include/linux/sched/prio.h:5:#define MIN_NICE	-20
kernel/locking/locktorture.c:219:	set_user_nice(current, 19);
kernel/sys.c:253:				niceval = 20 - task_nice(p);
kernel/sys.c:264:				niceval = 20 - task_nice(p);
kernel/sys.c:280:					niceval = 20 - task_nice(p);
kernel/workqueue.c:105:	RESCUER_NICE_LEVEL	= -20,
kernel/workqueue.c:106:	HIGHPRI_NICE_LEVEL	= -20,
tools/testing/selftests/mqueue/mq_perf_tests.c:532:	cur_nice = -20;


