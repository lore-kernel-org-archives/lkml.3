Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaHMPrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:47:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42501 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaHMPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:47:51 -0400
Message-ID: <53EB88A2.1070408@ti.com>
Date: Wed, 13 Aug 2014 10:47:46 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] rpmsg: compute number of buffers to allocate from vrings
References: <1404420815-42108-1-git-send-email-s-anna@ti.com> <CAK=WgbaRJNVXqbM+MyY+UtUYYCnR2t3CP5UdTXSpLJy=MTJKJQ@mail.gmail.com> <53EA3E78.6000304@ti.com> <CAK=WgbYLUcnK1p0qUkfONavk+W1eXg5fcaTNcU4W3ova6wySuQ@mail.gmail.com>
In-Reply-To: <CAK=WgbYLUcnK1p0qUkfONavk+W1eXg5fcaTNcU4W3ova6wySuQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 08/13/2014 08:40 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Tue, Aug 12, 2014 at 7:19 PM, Suman Anna <s-anna@ti.com> wrote:
>> Yes, I was playing around with using less buffers in the remoteproc
>> resource table for the vrings. The remoteproc virtio code creates the
>> vrings using the number of buffers based on .num field value of struct
>> fw_rsc_vdev_vring in the resource table. The virtio rpmsg probe code
>> though tries to set up the receive buffers for the same virtqueue based
>> on the current hard-coded value of 512 buffers and virtqueue_add_inbuf
>> would fail as the virtqueue is created with less number of buffers and
>> throws a WARN_ON.
> 
> Gotcha - thanks for the details.
> 
> Limiting the number of buffers in case the vrings are too small makes
> sense, but let's use RPMSG_NUM_BUFS as an upper bound, so wacky
> resource tables won't trigger unreasonable memory waste.
> 
> Something in the lines of:
> 
> vrp->num_bufs = min(PMSG_NUM_BUFS, virtqueue_get_vring_size(vrp->rvq) * 2);
> 
> Should probably do the trick.
> 
> Does this satisfy your requirement?

Yeah, this will work for me. I will go ahead and add a WARN_ON as well
to detect above wacky condition, and if someone really needs more
buffers in the future, we can revisit this.

regards
Suman
