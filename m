Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaG0QWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 12:22:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:54724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaG0QWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 12:22:03 -0400
Message-ID: <53D527BB.30309@kernel.org>
Date: Sun, 27 Jul 2014 17:24:27 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: questions regarding drivers/staging/iio/accel/sca3000_core.c
References: <CAB78YHyh88+j-knC1HZQinnLU=9wbVPXrYRF81LeOtrV1oGmZA@mail.gmail.com>
In-Reply-To: <CAB78YHyh88+j-knC1HZQinnLU=9wbVPXrYRF81LeOtrV1oGmZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 09:24, Himangi Saraogi wrote:
> Hi,
>
> I was looking at the possibility of using a managed interface for
> iio_device_register in sca3000_probe. But this will lead to the
> iio_device_unregister function being called after
> sca3000_unconfigure_ring in the remove function. I have a few
> queries:
>
> 1. Is it safe to move the unregister function over the
> sca3000_unconfigure_ring?
No, in fact it should be before various other things
(though it isn't currently).  The device unregister
removes the userspace interfaces.  Hence it should always
be called before anything else happens in a remove function.
>
> 2. Is it correct that on failure the probe function does not call
> sca3000_unconfigure_ring?
Nope. That's a bug.  Actually the whole probe function ordering is
suspicious. The device register should probably be a lot later
(i.e. last). There might be some esoteric reason that isn't the case
but I honestly can't remember.  Whilst I have one of these parts
the wire bodge needs repairing and I haven't fired the board it plugs
into up for a good while.  If it wasn't such and interesting part I'd
be tempted to suggest dropping the driver entirely (and find out if
anyone else actually has one in the process!)
>
> 3. If it is fine moving unregister after sca3000_unconfigure_ring, I
> propose to add a devm counterpart of iio_buffer_unregister. Is it a
> good idea?
I'm not sure there enough users to bother and some of those should
probably use the triggered_buffer helper functions.
>
> Thanks, Himangi
