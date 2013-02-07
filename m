Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3BGNbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:31:04 -0500
Message-ID: <5113AC8E.5030508@redhat.com>
Date: Thu, 07 Feb 2013 14:30:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com> <20130207130912.GA20875@redhat.com> <5113A8B0.5080104@redhat.com> <20130207132349.GA21707@redhat.com> <5113AA35.3010209@redhat.com> <20130207133133.GC21707@redhat.com>
In-Reply-To: <20130207133133.GC21707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/02/2013 14:31, Michael S. Tsirkin ha scritto:
> > Single means *this piece* (for example a request header) is single.  It
> > could still end up in an indirect buffer because QEMU does not support
> > mixed direct/indirect buffers.
> 
> Yes but why is the optimization worth it?
> It makes sense if all we want to do is add a single buffer
> in one go, this would give us virtqueue_add_buf_single.
> 
> But if we are building up an s/g list anyway,
> speeding up one of the entries a tiny bit
> seems very unlikely to be measureable.
> No?

There is some optimization potential even in unrolling the loop, but
yes, it looks like I misunderstood.  I'll add virtqueue_add_buf_single
instead.

Paolo

