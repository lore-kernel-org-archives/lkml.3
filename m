Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab3CTBrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:47:05 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:54214 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3CTBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:47:03 -0400
Date: Tue, 19 Mar 2013 18:46:57 -0700
From: Venkatesh Srinivas <venkateshs@google.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com,
        virtualization@lists.linux-foundation.org, pbonzini@redhat.com,
        vsrinivas@ops101.org, digitaleric@google.com, mikew@google.com
Subject: Re: [PATCH V5 4/5] virtio-scsi: introduce multiqueue support
Message-ID: <20130320014657.GA14714@google.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1363687057-13580-5-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks pretty good!

I rather like the (lack of) locking in I/O completion (around the req
count vs. target/queue binding). It is unfortunate that you need to 
hold the per-target lock in virtscsi_pick_vq() though; have any idea
how much that lock hurts?

Just two minor comments:

(in struct virtio_scsi_target_data):
+       /* This spinlock never help at the same time as vq_lock. */
                                ^^^^ held?

(in struct virtio_scsi):
+       /* Does the affinity hint is set for virtqueues? */
Could you rephrase that, please?

Tested on qemu and w/ Google Compute Engine's virtio-scsi device.

Reviewed-and-tested-by: Venkatesh Srinivas <venkateshs@google.com>

Thanks,
-- vs;
