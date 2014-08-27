Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765AbaH0OOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:14:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61862 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbaH0OOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <53FDEA48.9030301@intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com> <53FDEA48.9030301@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 27 Aug 2014 16:14:01 +0200
Message-ID: <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least I have seen the issue on Debian 3.14 and 3.16. Is your patch
going to be backported to linux-stable? The computer crashes very very
badly

On Wed, Aug 27, 2014 at 4:25 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
> On 08/26/2014 06:47 PM, Ricardo Ribalda Delgado wrote:
>> While testing a usb gadget I managed to crash completely the host
>> computer. This was due to a NULL pointer derefence.
>>
>> This patch avoids the crash although the kernel still outputs some
>> warnings.
>>
>> Without this patch, kernels from (at least) 3.14 can be crashed with
>> mass storage gadgets.
>>
>> Affected host:  NEC Corporation uPD720200 USB 3.0
>>
>
>
> This should not be necessary anymore after
> commit 365038d83313951d6ace15342eb24624bbef1666
>     xhci: rework cycle bit checking for new dequeue pointers
>
> http://marc.info/?l=linux-usb&m=140844993115671&w=2
>
> Which was just added to Greg's usb-linus branch.
> It checks that the new_deq_ptr and new_deq_seg are valid before calling
> xhci_queue_new_dequeue_state()
>
> -Mathias
>
>
>
>
>



-- 
Ricardo Ribalda
