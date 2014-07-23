Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaGWUR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:17:28 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56382 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaGWUR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:17:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjrFzrveTuYeZQ1o7XEYP_pcmF0Z9b2_Y9eGVidvzy+ig@mail.gmail.com>
References: <CAPDOMVjrFzrveTuYeZQ1o7XEYP_pcmF0Z9b2_Y9eGVidvzy+ig@mail.gmail.com>
Date: Wed, 23 Jul 2014 13:10:29 -0700
X-Google-Sender-Auth: B02Ye4HB2KsLWEKTlFIqppDDVrI
Message-ID: <CAMbhsRRP2xE2UHqJd-X=ggsc=rqzhwTwVKpaYGMjC840YhTSYg@mail.gmail.com>
Subject: Re: staging: Unwritten function for ion_carveout_heap.c
From: Colin Cross <ccross@android.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>,
        Laura Abbott <lauraa@codeaurora.org>, gioh.kim@lge.com,
        benjamin.gaignard@linaro.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 1:04 PM, Nick Krause <xerofoify@gmail.com> wrote:
> Hey Greg and others.
> Sorry for another email but it seems the function,
> ion_carveout_heap_unmap_dma is
> just returning and not doing anything useful. Furthermore I am new so
> I don't known how
> to write this function but this may  be causing  some rather  serious
> bugs as if the dma heap
> is not unmaped and we  call this function a lot this will make the
> kernel not able to handle dma requests
> for this driver and other drivers that need this and in turn lead to
> a oops or even a kernel panic due to leaked
> dma allocated memory. I would recommend writing this function or
> helping me write it in
> other to avoid some rather serious bugs without a proper dma unmapping
> function for this driver  :).
> Nick

Look at ion_carveout_heap_map_dma - it doesn't do anything, it just
returns a pre-existing virtual address.  That means there is nothing
to do in unmap.

map_dma is actually a bit of a misnomer here, as the actual mapping is
done in ion_map_dma_buf.  All ion_carveout_heap_map_dma does is return
the sg table for ion_map_dma_buf to pass to dma_map_sg.
