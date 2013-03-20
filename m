Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3CTHXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:23:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65124 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab3CTHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:23:12 -0400
X-IronPort-AV: E=Sophos;i="4.84,876,1355068800"; 
   d="scan'208";a="6908534"
Message-ID: <51496430.6000804@cn.fujitsu.com>
Date: Wed, 20 Mar 2013 15:24:32 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Venkatesh Srinivas <venkateshs@google.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com,
        virtualization@lists.linux-foundation.org, pbonzini@redhat.com,
        vsrinivas@ops101.org, digitaleric@google.com, mikew@google.com,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com> <1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com> <20130320014657.GA14714@google.com>
In-Reply-To: <20130320014657.GA14714@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 15:21:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 15:21:45,
	Serialize complete at 2013/03/20 15:21:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 09:46 AM, Venkatesh Srinivas wrote:
> This looks pretty good!
> 
> I rather like the (lack of) locking in I/O completion (around the req
> count vs. target/queue binding). It is unfortunate that you need to hold the per-target lock in virtscsi_pick_vq() though; have any idea
> how much that lock hurts?

Paolo?

> 
> Just two minor comments:
> 
> (in struct virtio_scsi_target_data):
> +       /* This spinlock never help at the same time as vq_lock. */
>                                ^^^^ held?
> 
> (in struct virtio_scsi):
> +       /* Does the affinity hint is set for virtqueues? */
> Could you rephrase that, please?

Thank you, fixed in V6, please review.

> 
> Tested on qemu and w/ Google Compute Engine's virtio-scsi device.

Cool.

> 
> Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>

Do you mind review and test the V6? Thank you.

Regards,
Wanlong Gao

> 
> Thanks,
> -- vs;
> 

