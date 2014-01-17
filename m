Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaAQBn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:43:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQBn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:43:56 -0500
Date: Thu, 16 Jan 2014 20:43:51 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, riel@redhat.com,
        aarcange@redhat.com, aquini@redhat.com, mst@redhat.com,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        alitke@redhat.com
Subject: Re: [RFC PATCH 3/4] virtio_balloon: add pressure notification via a
 new virtqueue
Message-ID: <20140116204351.7d48c2b9@redhat.com>
In-Reply-To: <20140116203819.0e7be6d4@redhat.com>
References: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
	<1389889445-3855-4-git-send-email-lcapitulino@redhat.com>
	<87y52ftus0.fsf@rustcorp.com.au>
	<20140116203819.0e7be6d4@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 20:38:19 -0500
Luiz Capitulino <lcapitulino@redhat.com> wrote:

> > What does qemu do with this information?
> 
> There are two possible scenarios:
> 
>  1. The balloon driver is currently inflating when it gets under
>     pressure
> 
>     QEMU resets "num_pages" to the current balloon size. This
>     cancels the on-going inflate
> 
>  2. The balloon driver is not inflating, eg. it's possibly sleeping
> 
>    QEMU issues a deflate
> 
> But note that those scenarios are not supposed to be used with the
> current device, they are part of the automatic ballooning feature.
> I CC'ed you on the QEMU patch, you can find it here case you didn't
> see it:
> 
>  http://marc.info/?l=kvm&m=138988966315690&w=2

By "current device" I meant "outside of automatic ballooning scope".
