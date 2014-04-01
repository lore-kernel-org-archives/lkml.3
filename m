Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaDAR4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:56:02 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36740 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaDARz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:55:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Anton Leontiev <bunder@t-25.ru>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Fix marking buffer erroneous in case of FID toggling
Date: Tue, 01 Apr 2014 17:24:14 +0200
Message-ID: <10422468.Ah80osK73i@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <533659E2.4010001@t-25.ru>
References: <1395722457-28080-1-git-send-email-bunder@t-25.ru> <1459346.J1YUbuH55p@avalon> <533659E2.4010001@t-25.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Saturday 29 March 2014 09:28:02 Anton Leontiev wrote:
> 28.03.2014 20:12, Laurent Pinchart пишет:
> >>>> + * Set error flag for incomplete buffer.
> >>>> + */
> >>>> +static void uvc_buffer_check_bytesused(const struct uvc_streaming
> >>>> *const stream,
> > 
> > No need for the second const keyword here.
> > 
> > I would have used "uvc_video_" as a prefix, to be in sync with the
> > surrounding functions. What would you think of
> > uvc_video_validate_buffer() ?
> > 
> >>>> +	struct uvc_buffer *const buf)
> > 
> > And no need for const at all here.
> > 
> >>>> +{
> >>>> +	if (buf->length != buf->bytesused &&
> >>>> +			!(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
> > 
> > The indentation is wrong here, the ! on the second line should be aligned
> > to the first 'buf' of the first line.
> > 
> > If you agree with these changes I can perform them while applying, there's
> > no need to resubmit the patch.
> 
> Thank you for reviewing my first patch to Linux kernel.

Thank you for submitting it :-)

> I completely agree with your changes.
> 
> Just want to ask why there is no need for the second 'const' after pointer
> character '*'? I thought it marks pointer itself as constant for type-
> checking opposite to first 'const', which marks memory it points to as
> constant for type-checking.

Your understanding is correct (as far as I know).

> I understand that the function is simple enough to verify it by hand but
> it's better to add more information for automatic checking.
>
> Is there any guidelines on 'const' keyword usage in Linux kernel code?

Marking the memory pointed to by the pointer as const ensures that the 
function won't modify memory that the caller thought wouldn't be modified. It 
thus serves as a contract between the caller and the callee, enforced by the 
compiler.

Marking the pointer as const, on the other hand, only affects the function 
implementation, without influencing its call contract. Its only use in this 
case would be to prevent the function from modifying a pointer that the 
function itself thought it shouldn't modify. While not useless in all cases, 
this compile-time checked if usually not performed in the kernel, especially 
for simple functions. I'm not aware of any explicit rule regarding const usage 
though.

-- 
Regards,

Laurent Pinchart

