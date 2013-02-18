Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3BRKAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:00:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3BRKAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:00:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,686,1355068800"; 
   d="scan'208";a="6723946"
Message-ID: <5121F521.6080300@cn.fujitsu.com>
Date: Mon, 18 Feb 2013 17:32:17 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v3 0/5] virtio-scsi multiqueue
References: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/18 17:32:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/18 17:32:27,
	Serialize complete at 2013/02/18 17:32:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 09:06 PM, Paolo Bonzini wrote:
> This series implements virtio-scsi queue steering, which gives
> performance improvements of up to 50% (measured both with QEMU and
> tcm_vhost backends).  The patches build on top of the new virtio APIs
> at http://permalink.gmane.org/gmane.linux.kernel.virtualization/18431;
> the new API simplifies the locking of the virtio-scsi driver nicely,
> thus it makes sense to require them as a prerequisite.
> 
> Changes from the previous post, which can be found at
> http://permalink.gmane.org/gmane.linux.kernel.virtualization/17869:
> 
> - patches 1 and 2 ("virtio: add functions for piecewise addition of
>   buffers", "virtio-scsi: use functions for piecewise composition of
>   buffers") split into their own series
> 
> - new cleanup patch "virtio-scsi: push vq lock/unlock into virtscsi_vq_done"
> 
> - reorganized code to move ACCESS_ONCE in a clearer place
> 
> - included Wanlong Gao's CPU hotplug patches
> 
> Ok for 3.9?  It would probably be easier to get it in via Rusty's tree
> because of the prerequisites.  James, can I get your Acked-by?

I can't apply this series on top of Rusty's virtio-next, I missed something
or needed rebase them ?

Thanks,
Wanlong Gao

> 
> Paolo
> 
> Paolo Bonzini (4):
>   virtio-scsi: redo allocation of target data
>   virtio-scsi: pass struct virtio_scsi to virtqueue completion function
>   virtio-scsi: push vq lock/unlock into virtscsi_vq_done
>   virtio-scsi: introduce multiqueue support
> 
> Wanlong Gao (1):
>   virtio-scsi: reset virtqueue affinity when doing cpu hotplug
> 
>  drivers/scsi/virtio_scsi.c |  360 +++++++++++++++++++++++++++++++++++---------
>  1 files changed, 292 insertions(+), 68 deletions(-)
> 
> 

