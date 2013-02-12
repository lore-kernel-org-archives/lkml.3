Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab3BLPci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:32:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571Ab3BLPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:32:37 -0500
Message-ID: <511A608B.5080007@redhat.com>
Date: Tue, 12 Feb 2013 16:32:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] virtio: add functions for piecewise addition of buffers
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <1360671815-2135-2-git-send-email-pbonzini@redhat.com> <20130212145620.GA3392@redhat.com>
In-Reply-To: <20130212145620.GA3392@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 15:56, Michael S. Tsirkin ha scritto:
>> > +/**
>> > + * virtqueue_start_buf - start building buffer for the other end
>> > + * @vq: the struct virtqueue we're talking about.
>> > + * @data: the token identifying the buffer.
>> > + * @nents: the number of buffers that will be added
> This function starts building one buffer, number of buffers
> is a bit weird here.

Ok.

>> > + * @nsg: the number of sg lists that will be added
> This means number of calls to add_sg ? Not sure why this matters.
> How about we pass in in_num/out_num - that is total # of sg,
> same as add_buf?

It is used to choose between direct and indirect.

>> > +/**
>> > + * virtqueue_add_sg - add sglist to buffer being built
>> > + * @_vq: the virtqueue for which the buffer is being built
>> > + * @sgl: the description of the buffer(s).
>> > + * @nents: the number of items to process in sgl
>> > + * @dir: whether the sgl is read or written (DMA_TO_DEVICE/DMA_FROM_DEVICE only)
>> > + *
>> > + * Note that, unlike virtqueue_add_buf, this function follows chained
>> > + * scatterlists, and stops before the @nents-th item if a scatterlist item
>> > + * has a marker.
>> > + *
>> > + * Caller must ensure we don't call this with other virtqueue operations
>> > + * at the same time (except where noted).
> Hmm so if you want to add in and out, need separate calls?
> in_num/out_num would be nicer?

If you want to add in and out just use virtqueue_add_buf...

Paolo

