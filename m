Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3KOMJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:09:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33016 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KOMJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:09:20 -0500
X-IronPort-AV: E=Sophos;i="4.93,707,1378857600"; 
   d="scan'208";a="72315876"
Message-ID: <52860EED.9020909@citrix.com>
Date: Fri, 15 Nov 2013 13:09:17 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.13-rc1] xen-blkfront: Silence pfn maybe-uninitialized
 warning
References: <1384464592-35970-1-git-send-email-tim.gardner@canonical.com> <17a2e4ab-d2dc-4bcc-a0fc-1eb1172876e5@email.android.com>
In-Reply-To: <17a2e4ab-d2dc-4bcc-a0fc-1eb1172876e5@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/13 23:24, Konrad Rzeszutek Wilk wrote:
> Tim Gardner <tim.gardner@canonical.com> wrote:
>> pfn cannot actually be used unless (!info->feature_persistent), nor is
>> pfn accessed in get_grant() unless (!info->feature_persistent), but
>> silence
>> this warning anyway. gcc-4.8
>>
>> drivers/block/xen-blkfront.c: In function 'do_blkif_request':
>> drivers/block/xen-blkfront.c:508:20: warning: 'pfn' may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
>>     gnt_list_entry = get_grant(&gref_head, pfn, info);
>>                    ^
>> drivers/block/xen-blkfront.c:492:19: note: 'pfn' was declared here
>>     unsigned long pfn;
>>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: David Vrabel <david.vrabel@citrix.com>
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

>> ---
>> drivers/block/xen-blkfront.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c
>> b/drivers/block/xen-blkfront.c
>> index 432db1b..5f926de 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -489,7 +489,7 @@ static int blkif_queue_request(struct request *req)
>>
>> 			if ((ring_req->operation == BLKIF_OP_INDIRECT) &&
>> 			    (i % SEGS_PER_INDIRECT_FRAME == 0)) {
>> -				unsigned long pfn;
>> +				unsigned long uninitialized_var(pfn);
>>
>> 				if (segments)
>> 					kunmap_atomic(segments);
> 
> I have a similar patch from Roger that sets pfn=0. 
> 
> Roger could you repost your patch please or if you feel that this patch makes sense then comment on it?

I'm fine with this patch, although I'm more used to the classic pfn = 0.

