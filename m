Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3BHGfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:35:52 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34308 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3BHGfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:35:51 -0500
Message-ID: <51149CC0.4080702@redhat.com>
Date: Fri, 08 Feb 2013 07:35:44 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        kvm@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com> <8738x7ih5o.fsf@rustcorp.com.au>
In-Reply-To: <8738x7ih5o.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/02/2013 05:05, Rusty Russell ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> The virtqueue_add_buf function has two limitations:
>>
>> 1) it requires the caller to provide all the buffers in a single call;
>>
>> 2) it does not support chained scatterlists: the buffers must be
>> provided as an array of struct scatterlist.
>>
>> Because of these limitations, virtio-scsi has to copy each request into
>> a scatterlist internal to the driver.  It cannot just use the one that
>> was prepared by the upper SCSI layers.
> 
> Hi Paulo,
> 
>         Note that you've defined your problem in terms of your solution
> here.  For clarity:

Good catch. :)

> The problem: we want to prepend and append to a scatterlist.  We can't
>         append, because the chained scatterlist implementation requires
>         an element to be appended to join two scatterlists together.
> 
> The solution: fix scatterlists by introducing struct sg_ring:
>         struct sg_ring {
>                 struct list_head ring;
>         	unsigned int nents;
>         	unsigned int orig_nents; /* do we want to replace sg_table? */
>                 struct scatterlist *sg;
>         };
> 
> The workaround: make virtio accept multiple scatterlists for a single
>         buffer.
> 
> There's nothing wrong with your workaround, but if other subsystems have
> the same problem we do, perhaps we should consider a broader solution?

Do they?  Given the resistance you have had on the topic, perhaps they
don't (though I agree that chained scatterlist are horrible).

But I'll add a note on this to the commit message and why the workaround
is IMHO acceptable.

Paolo
