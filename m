Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJPII4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:08:56 -0400
Received: from mailsec115.isp.belgacom.be ([195.238.20.111]:36893 "EHLO
	mailsec115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaJPIIw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:08:52 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=cGhLeOE9I35BcZRK2zxy3BlNJEt3JpyFGdx+8CmfgKw= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=zFUaYrZlOKmF9SEepzkA:9
 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYKAHN8P1TD7hTU/2dsb2JhbABbgw6BK4MGtTQGmx0CgRAWAX2EAgEBAQMBI1EFBQsFBhgCAhgOAgJXBgEJCRGIJQy0S4Z/jhMBAQEBBgEBAQEBHYEshHaJeTMHgneBVAWfBY1ThxiDeTsvgkoBAQE
Date: Thu, 16 Oct 2014 10:08:50 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>, =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Message-ID: <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <87iojm8qxp.fsf@nemi.mork.no>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be> <1413306955.3269.30.camel@joe-AO725> <87iojm8qxp.fsf@nemi.mork.no>
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by
 kzalloc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 14 October 2014 at 20:08 Bjørn Mork <bjorn@mork.no> wrote:
>
>
> Joe Perches <joe@perches.com> writes:
>
> > And does this really need to be alloc'd?
>
> Yes, it does. It is used as a transfer_buffer in usb_fill_bulk_urb() and
> must be "suitable for DMA".  From include/linux/usb.h:
>
> /**
>  * struct urb - USB Request Block
> ..
>  * @transfer_buffer:  This identifies the buffer to (or from) which the I/O
>  *      request will be performed unless URB_NO_TRANSFER_DMA_MAP is set
>  *      (however, do not leave garbage in transfer_buffer even then).
>  *      This buffer must be suitable for DMA; allocate it with
>  *      kmalloc() or equivalent.  For transfers to "in" endpoints, contents
>  *      of this buffer will be modified.  This buffer is used for the data
>  *      stage of control transfers.
>
>

Adding a structure would be a nice design update indeed but this would require
some testing...Separate patch maybe ?
 
Fabian

>
> Bjørn
