Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161989Ab3DEIzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:55:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab3DEIyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:54:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,413,1363104000"; 
   d="scan'208";a="7001748"
Message-ID: <515E918D.3090307@cn.fujitsu.com>
Date: Fri, 05 Apr 2013 16:55:41 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: JBottomley@parallels.com
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        venkateshs@google.com, pbonzini@redhat.com,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V7 0/5] virtio-scsi multiqueue
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com> <5153A953.2000101@cn.fujitsu.com>
In-Reply-To: <5153A953.2000101@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 16:53:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 16:53:48,
	Serialize complete at 2013/04/05 16:53:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 10:22 AM, Wanlong Gao wrote:
> On 03/23/2013 07:28 PM, Wanlong Gao wrote:
>> This series implements virtio-scsi queue steering, which gives
>> performance improvements of up to 50% (measured both with QEMU and
>> tcm_vhost backends).
>>
>> This version rebased on Rusty's virtio ring rework patches, which
>> has already gone into virtio-next today.
>> We hope this can go into virtio-next together with the virtio ring
>> rework pathes.
>>
>> V7: respin to fix the patch apply error
>>
>> V6: rework "redo allocation of target data" (James)
>>     fix comments (Venkatesh)
>>     rebase to virtio-next
>>
>> V5: improving the grammar of 1/5 (Paolo)
>>     move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)
>>
>> V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)
>>
>> V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2
>>
>>
>> It would probably be easier to get it in via Rusty's tree
>> because of the prerequisites.  James, can we get your Acked-by?
> 
> James, any thoughts for this version?

Ping James....


> 
> Thanks,
> Wanlong Gao
> 
>>
>> Paolo Bonzini (3):
>>   virtio-scsi: pass struct virtio_scsi to virtqueue completion function
>>   virtio-scsi: push vq lock/unlock into virtscsi_vq_done
>>   virtio-scsi: introduce multiqueue support
>>
>> Wanlong Gao (2):
>>   virtio-scsi: redo allocation of target data
>>   virtio-scsi: reset virtqueue affinity when doing cpu hotplug
>>
>>  drivers/scsi/virtio_scsi.c | 387 ++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 309 insertions(+), 78 deletions(-)
>>
> 
> 

