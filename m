Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3E0RNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:13:45 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:38135 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3E0RNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:13:42 -0400
Message-ID: <51A39441.9000609@cogentembedded.com>
Date: Mon, 27 May 2013 21:13:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] USB: hcd: only unmap the actual completed DMA buffer
References: <1369671187-24430-1-git-send-email-ming.lei@canonical.com> <1369671187-24430-3-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1369671187-24430-3-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-05-2013 20:13, Ming Lei wrote:

> This patch only unmap the actual completed DMA buffer instead of
> the whole transfer buffer.

     Who will unmap the rest of the buffer?

> It is common to see only part of DMA transfer is completed, especially
> in case of DMA_FROM_DEVICE because the length of incoming traffic often
> is unknown before submitting URB, so this patch may improve USB
> DMA unmapping which runs in hard irq context.

> The patch has been tested on ARMv7(Pandaboard), and it is observed that
> at average ~25us is saved about ehci interrupt handling on below usbnet
> test case:

> 	- Pandaboard: IP address is IP_A
> 	- on one x86 box, run below command:
> 		#ping -f -s 1472 IP_A
> 	- compute ehci interrupt handling time on Pandaboard during ping
> 	  test

    This seems just crazy to me. What has been mapped, should be unmapped.

> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/usb/core/hcd.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

WBR, Sergei


