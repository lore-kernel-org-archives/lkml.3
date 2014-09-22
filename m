Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaIVKlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:41:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44187 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbaIVKlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:41:05 -0400
From: Yifan Zhang <zhangyf@marvell.com>
To: Tejun Heo <tj@kernel.org>
CC: Jing Xiang <jxiang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yifan.zhangm@gmail.com" <yifan.zhangm@gmail.com>
Date: Mon, 22 Sep 2014 03:40:55 -0700
Subject: RE: [PATCH] workqueue: fix a workqueue kernel panic issue.
Thread-Topic: [PATCH] workqueue: fix a workqueue kernel panic issue.
Thread-Index: Ac/WFt3mDhmDSLueTfO2Io3NtFPQNAAOKb8w
Message-ID: <4737A960563B524DA805CA602BE04B307EEEA98F6B@SC-VEXCH2.marvell.com>
References: <1410941884-26034-1-git-send-email-zhangyf@marvell.com>
 <4737A960563B524DA805CA602BE04B307EEE6C2694@SC-VEXCH2.marvell.com>
 <20140922033946.GA23583@htj.dyndns.org>
In-Reply-To: <20140922033946.GA23583@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-22_01:2014-09-19,2014-09-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409220108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8MAfCdA027661

Hi Tejun,

This issue is found when we got a kernel panic:

[  943.673177] c3 7843 (Thread-162) pwm-vibrator pwm-vibrator: Vibrator: Set duration: 10ms
[  943.717242] c0 7843 (Thread-162) pwm-vibrator pwm-vibrator: Vibrator: Set duration: 30ms
[  949.571415] c1 779 (Binder_3) B52ISP version: HW 3.36, SWM 1.4, revision 871
[  949.579291] c1 779 (Binder_3) b52_sensor_set_fmt: mbus code not match
[  949.749224] c0 779 (Binder_3) b52_sensor_set_fmt: mbus code not match
[  949.803474] c0 7844 (kworker/0:2) Unable to handle kernel NULL pointer dereference at virtual address 00000008
[  949.813433] c0 7844 (kworker/0:2) pgd = ffffffc00007d000

[  949.818707] c0 7844 (kworker/0:2) [00000008] *pgd=0000000001214003, *pmd=0000000001215003, *pte=00e00000d4200407
[  949.829002] c0 7844 (kworker/0:2) Internal error: Oops: 96000007 [#1] PREEMPT SMP
[  949.836425] Modules linked in: tzdd galcore ssipcmisck(P) audiostub cidatattydev gs_modem ccinetdev cci_datastub citty iml_module seh cploaddev msocketk
[  949.850077] c0 7844 (kworker/0:2) CPU: 0 PID: 7844 Comm: kworker/0:2 Tainted: P             3.10.33 #1
[  949.859318] c0 7844 (kworker/0:2) task: ffffffc015517500 ti: ffffffc027c48000 task.ti: ffffffc027c48000
[  949.868641] c0 7844 (kworker/0:2) PC is at process_one_work+0x38/0x410
[  949.875110] c0 7844 (kworker/0:2) LR is at worker_thread+0x13c/0x3c0
[  949.881407] c0 7844 (kworker/0:2) pc : [<ffffffc0000bbbd4>] lr : [<ffffffc0000bcab8>] pstate: 600001c5
[  949.890634] c0 7844 (kworker/0:2) sp : ffffffc027c4bd60
[  949.895810] R29: ffffffc027c4bd60 R28: 0000000000000009 
[  949.901091] R27: ffffffc0008da108 R26: 0000000000000001 
[  949.906372] R25: ffffffc000aa2902 R24: 0000000000000000 
[  949.911653] R23: ffffffc027c48000 R22: ffffffc02b3b11b0 
[  949.916934] R21: ffffffc034da09c0 R20: ffffffc02b3b1180 
[  949.922215] R19: ffffffc000c05380 R18: 0000000000000000 
[  949.927497] R17: 0000000000000000 R16: ffffffc0001909a4 
[  949.932777] R15: 0000000000000000 R14: 000000000000ca81 
[  949.938059] R13: 00000000f6f99a80 R12: 00000000000003d1 
[  949.943341] R11: 0000000000000004 R10: ffffffc000bef3a8 
[  949.948622] R9 : ffffffc027c4bbe0 R8 : ffffffc015517920 
[  949.953903] R7 : ffffffc000724d98 R6 : ffffffc000724d98 
[  949.959183] R5 : 0000000000000000 R4 : 0000000000000000 
[  949.964465] R3 : ffffffc034da0d40 R2 : ffffffc034da09c0 
[  949.969746] R1 : ffffffc000c05380 R0 : 0000000000000000 
[  949.975019] c0 7844 (kworker/0:2) 
[  949.978390] c0 7844 (kworker/0:2) 
[  949.978390] PC: ffffffc0000bbb54:

You can tell it is a bug when pwq = get_work_pwq() return NULL, and cpu_intensive = pwq->wq->flags use it w/o check. 

Normally get_work_pwq doesn't return NULL, but we had a bug in code which makes INIT_WORK(&work, do_work) is called in multi-thread. In some cases, work_struct is re-init just before get_work_pwq is called, it makes work_struct->data is invalid and thus causes the problem. It is indeed a bug of ourselves, and after fix it there is no such issue. But I wonder we still a NULL check before dereference pwq here anyway, since get_work_pwq may return NULL in some cases.

What do you think :-) ?

BR,
YIfan


-----Original Message-----
From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
Sent: 2014å¹´9æœˆ22æ—¥ 11:40
To: Yifan Zhang
Cc: Jing Xiang; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix a workqueue kernel panic issue.

On Sun, Sep 21, 2014 at 08:30:32PM -0700, Yifan Zhang wrote:
> Hi Tejun,
> 
> What's do you think of this patch ? Any concern ?

Hmmm?  Haven't I already responded to this patch?

> -----Original Message-----
> From: Yifan Zhang [mailto:zhangyf@marvell.com]
> Sent: 2014å¹´9æœˆ17æ—¥ 16:18
> To: Tejun Heo; Jing Xiang; linux-kernel@vger.kernel.org
> Cc: Yifan Zhang
> Subject: [PATCH] workqueue: fix a workqueue kernel panic issue.
> 
> if created workqueue in multi-thread unsynchronized,

Can you please elaborate?

> get_work_pwq() may return NULL, which cause kernel panic. Judge 
> get_work_pwq() return value before use
> pwq->wq->flags.
> 
> Signed-off-by: Yifan Zhang <zhangyf@marvell.com>
> ---
>  kernel/workqueue.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c index 
> 5dbe22a..d3ac87f 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1947,9 +1947,19 @@ __acquires(&pool->lock)  {
>  	struct pool_workqueue *pwq = get_work_pwq(work);
>  	struct worker_pool *pool = worker->pool;
> -	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
> +	bool cpu_intensive;
>  	int work_color;
>  	struct worker *collision;
> +
> +	if (pwq == NULL) {
> +		pr_err("BUG: invalid struct work_struct.data %lu\n",
> +				atomic_long_read(&work->data));
> +		dump_stack();
> +		return;

I have difficult time seeing how the above piece of code would be acceptable but maybe the situation you're trying to explain is weird enough to justify it.

Thanks.

--
tejun
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
