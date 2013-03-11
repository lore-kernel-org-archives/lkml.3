Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3CKLbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3CKLbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:31:36 -0400
Message-ID: <513DC087.6000508@redhat.com>
Date: Mon, 11 Mar 2013 12:31:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        asias@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com
Subject: Re: [PATCH V4 1/5] virtio-scsi: redo allocation of target data
References: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com> <1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1362969842-9145-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/03/2013 03:43, Wanlong Gao ha scritto:
> virtio_scsi_target_state is now empty, but we will find new uses
> for it in the next few patches.  However, dropping the sglist lets
> us turn the array-of-pointers into a simple array, which simplifies
> the allocation.
> 
> However, we do not leave the virtio_scsi_target_state structs in the
> flexible array member at the end of struct virtio_scsi, because
> we will place the virtqueues there in the next patches.

If you have to respin, consider improving the grammar:

virtio_scsi_target_state is now empty.  We will find new uses for it in
the next few patches, so this patch does not drop it completely.
However, having dropped the sglist flexible array member, we can turn
the tgt array-of-pointers into a simple array.  This simplifies the
allocation.

Even simpler would be to place the virtio_scsi_target_state structs in a
flexible array member at the end of struct virtio_scsi.  But we do not
do that, because we will place the virtqueues there in the next patches.

Paolo

> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

