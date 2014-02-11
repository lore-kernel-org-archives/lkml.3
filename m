Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaBKSPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:15:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62551 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBKSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:15:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,826,1384300800"; 
   d="scan'208";a="99881366"
Message-ID: <52FA68AE.6070608@citrix.com>
Date: Tue, 11 Feb 2014 19:15:10 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <mrushton@amazon.com>,
        <msw@amazon.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.14 : NFO: trying
 to register non-static key. the code is fine but needs lockdep annotation.
References: <20140210184412.GA18198@phenom.dumpdata.com>	<20140210195402.GA3924@kernel.dk>	<771950784.20140211165215@eikelenboom.it>	<20140211155650.GA23026@phenom.dumpdata.com>	<1542261541.20140211170750@eikelenboom.it> <52FA6072.40908@citrix.com> <52FA6352.1010403@citrix.com>
In-Reply-To: <52FA6352.1010403@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/14 18:52, David Vrabel wrote:
> On 11/02/14 17:40, Roger Pau Monné wrote:
>> On 11/02/14 17:07, Sander Eikelenboom wrote:
>>>
>>> Tuesday, February 11, 2014, 4:56:50 PM, you wrote:
>>>
>>>> On Tue, Feb 11, 2014 at 04:52:15PM +0100, Sander Eikelenboom wrote:
>>>>> Hi Konrad,
>>>>>
>>>>> Today decided to tryout another kernel RC and your pull request to Jens on top of it .. and I encoutered this one:
>>>
>>>> Thank you for testing!
>>>
>>>> Could you provide the .config file please?
>>>
>>> Attached
>>>
>>>> Did you see this _before_ the pull request with Jens? I presume
>>>> not, but just double checking?
>>>
>>> Nope not too my knowledge (though it's a bit messy with things broken on 3.14 at the moment)
>>>
>>>> And lastly - what were you doing when you triggered this? Just launching
>>>> a guest?
>>>
>>> Nope it triggers on guest shutdown ..
>>>
>>>
>>>> CC-ing Roger and other folks who were on the patches.
>>>
>>>>>
>>>>>
>>>>> [  438.029756] INFO: trying to register non-static key.
>>>>> [  438.029759] the code is fine but needs lockdep annotation.
>>>>> [  438.029760] turning off the locking correctness validator.
>>>>> [  438.029770] CPU: 3 PID: 9593 Comm: blkback.2.xvda Tainted: G        W    3.14.0-rc2-20140211-pcireset-net-btrevert-xenblock+ #1
>>>>> [  438.029773] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
>>>>> [  438.029784]  ffff88005224c4f0 ffff88004e5d9b68 ffffffff81b808c4 ffff88004ba2b510
>>>>> [  438.029791]  0000000000000002 ffff88004e5d9c38 ffffffff81116eab ffff88004e5d9bf8
>>>>> [  438.029798]  ffffffff81117b35 0000000000000000 0000000000000000 ffffffff82cee570
>>>>> [  438.029799] Call Trace:
>>>>> [  438.029815]  [<ffffffff81b808c4>] dump_stack+0x46/0x58
>>>>> [  438.029826]  [<ffffffff81116eab>] __lock_acquire+0x1c2b/0x2220
>>>>> [  438.029833]  [<ffffffff81117b35>] ? lock_acquire+0xe5/0x150
>>>>> [  438.029841]  [<ffffffff81117b0d>] lock_acquire+0xbd/0x150
>>>>> [  438.029847]  [<ffffffff810e5965>] ? flush_work+0x5/0x290
>>>>> [  438.029852]  [<ffffffff810e599d>] flush_work+0x3d/0x290
>>>>> [  438.029856]  [<ffffffff810e5965>] ? flush_work+0x5/0x290
>>>>> [  438.029863]  [<ffffffff81117b35>] ? lock_acquire+0xe5/0x150
>>>>> [  438.029872]  [<ffffffff816fef01>] ? xen_blkif_schedule+0x1a1/0x8d0
>>>>> [  438.029881]  [<ffffffff81b8ae0d>] ? _raw_spin_unlock_irqrestore+0x6d/0x90
>>>>> [  438.029888]  [<ffffffff8111392b>] ? trace_hardirqs_on_caller+0xfb/0x240
>>>>> [  438.029894]  [<ffffffff81113a7d>] ? trace_hardirqs_on+0xd/0x10
>>>>> [  438.029901]  [<ffffffff816fefe9>] xen_blkif_schedule+0x289/0x8d0
>>>>> [  438.029907]  [<ffffffff8110d510>] ? __init_waitqueue_head+0x60/0x60
>>>>> [  438.029913]  [<ffffffff81113a7d>] ? trace_hardirqs_on+0xd/0x10
>>>>> [  438.029919]  [<ffffffff81b8ae21>] ? _raw_spin_unlock_irqrestore+0x81/0x90
>>>>> [  438.029925]  [<ffffffff816fed60>] ? xen_blkif_be_int+0x40/0x40
>>>>> [  438.029932]  [<ffffffff810ee374>] kthread+0xe4/0x100
>>>>> [  438.029938]  [<ffffffff81b8afe0>] ? _raw_spin_unlock_irq+0x30/0x50
>>>>> [  438.029946]  [<ffffffff810ee290>] ? __init_kthread_worker+0x70/0x70
>>>>> [  438.029951]  [<ffffffff81b8c1fc>] ret_from_fork+0x7c/0xb0
>>>>> [  438.029958]  [<ffffffff810ee290>] ? __init_kthread_worker+0x70/0x70
>>>>>
>>>>> Doesn't seem to serious .. but never the less :-)
>>
>> Thanks for the report!
>>
>> Does the following patch solve the problem?
>>
>> ---
>> commit c1460953d081c8a18ac9e84fe90f696cdceae105
>> Author: Roger Pau Monne <roger.pau@citrix.com>
>> Date:   Tue Feb 11 17:21:19 2014 +0100
>>
>>     xen-blkback: init persistent_purge_work work_struct
>>     
>>     Do a dummy initialization of the persistent_purge_work
>>     work_struct on xen_blkif_alloc, so that when flush_work is called on
>>     shutdown the struct is initialized even if it hasn't been used.
>>     
>>     Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>>
>> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
>> index 84973c6..3df7575 100644
>> --- a/drivers/block/xen-blkback/xenbus.c
>> +++ b/drivers/block/xen-blkback/xenbus.c
>> @@ -129,6 +129,17 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>>  	blkif->free_pages_num = 0;
>>  	atomic_set(&blkif->persistent_gnt_in_use, 0);
>>  	atomic_set(&blkif->inflight, 0);
>> +	/*
>> +	 * Init the work struct with a NULL function, this is done
>> +	 * so that flush_work doesn't complain when shutting down if
>> +	 * persistent_purge_work has not been used during the lifetime
>> +	 * of this blkback instance.
>> +	 *
>> +	 * NB: In purge_persistent_gnt we make sure that
>> +	 * persistent_purge_work is always correctly setup with a valid
>> +	 * function pointer before being scheduled.
>> +	 */
>> +	INIT_WORK(&blkif->persistent_purge_work, NULL);
> 
> I think you should init this fully here and remove the other call to
> INIT_WORK.

That would mean that unmap_purged_grants would no longer be static and 
I should also add a prototype for it in blkback/common.h, which is kind 
of ugly IMHO.

---
commit 980e72e45454b64ccb7f23b6794a769384e51038
Author: Roger Pau Monne <roger.pau@citrix.com>
Date:   Tue Feb 11 19:04:06 2014 +0100

    xen-blkback: init persistent_purge_work work_struct
    
    Initialize persistent_purge_work work_struct on xen_blkif_alloc (and
    remove the previous initialization done in purge_persistent_gnt). This
    prevents flush_work from complaining even if purge_persistent_gnt has
    not been used.
    
    Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index e612627..10cd50b 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -299,7 +299,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 	BUG_ON(num != 0);
 }
 
-static void unmap_purged_grants(struct work_struct *work)
+void xen_blkbk_unmap_purged_grants(struct work_struct *work)
 {
 	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
@@ -420,7 +420,6 @@ finished:
 	blkif->vbd.overflow_max_grants = 0;
 
 	/* We can defer this work */
-	INIT_WORK(&blkif->persistent_purge_work, unmap_purged_grants);
 	schedule_work(&blkif->persistent_purge_work);
 	pr_debug(DRV_PFX "Purged %u/%u\n", (total - num_clean), total);
 	return;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9eb34e2..be05277 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -385,6 +385,7 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 int xen_blkbk_barrier(struct xenbus_transaction xbt,
 		      struct backend_info *be, int state);
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
+void xen_blkbk_unmap_purged_grants(struct work_struct *work);
 
 static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 					struct blkif_x86_32_request *src)
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 84973c6..9a547e6 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -129,6 +129,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
 	atomic_set(&blkif->inflight, 0);
+	INIT_WORK(&blkif->persistent_purge_work, xen_blkbk_unmap_purged_grants);
 
 	INIT_LIST_HEAD(&blkif->pending_free);
 


