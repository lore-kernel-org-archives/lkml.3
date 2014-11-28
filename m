Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaK1RH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:07:28 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58836 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaK1RHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:07:23 -0500
MIME-Version: 1.0
In-Reply-To: <4838705.gmGJIAUqrM@avalon>
References: <1417044344-20611-1-git-send-email-prabhakar.csengg@gmail.com> <4838705.gmGJIAUqrM@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 28 Nov 2014 17:06:52 +0000
Message-ID: <CA+V-a8sAUDo+ut1t2_twy6hNjX5WQpridCEm6NrNmrwQvR1Nrw@mail.gmail.com>
Subject: Re: [PATCH v3] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thu, Nov 27, 2014 at 9:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
[Snip]
>>
>> +     queue->queue.lock = &queue->mutex;
>
> I'm a bit concerned that this would introduce future breakages. Setting the
> queue.lock pointer enables locking in all vb2_fop_* and vb2_ops_wait_*
> functions. The uvcvideo driver isn't ready for that, but doesn't use the
> vb2_fop_* functions yet, so that's not an issue. However, in the future,
> videobuf2 might use the lock in more places, including functions used by the
> uvcvideo driver. This could then cause breakages.
>
Even if in future if videobuf2 uses this lock it would be in helpers mostly,
so any way it doesn’t harm :)

> It would be better to completely convert the uvcvideo driver to the vb2_fop_*
> functions if we want to use vb2_ops_*. I'm not sure how complex that would be
> though, and whether it would be possible while still keeping the fine-grained
> locking implemented by the uvcvideo driver. Do you think it should be
> attempted ?
>
mmap & poll should be fairly simple, looks like open & release cannot be dropped
as it does some usb_autopm_get/put_interface() calls which I am not aware of.

Thanks,
--Prabhakar Lad

>>       ret = vb2_queue_init(&queue->queue);
>>       if (ret)
>>               return ret;
>
> --
> Regards,
>
> Laurent Pinchart
>
