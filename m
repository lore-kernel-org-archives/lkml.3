Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaKCPQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:16:03 -0500
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51742 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaKCPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:15:59 -0500
Message-ID: <54579C25.5060705@xs4all.nl>
Date: Mon, 03 Nov 2014 16:15:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
CC: ismael.luceno@corp.bluecherry.net, m.chehab@samsung.com
Subject: Re: [PATCH 4/4] [media] solo6x10: don't turn off/on encoder interrupt
 in processing loop
References: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com> <1414598634-13446-4-git-send-email-andrey.krieger.utkin@gmail.com>
In-Reply-To: <1414598634-13446-4-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On 10/29/2014 05:03 PM, Andrey Utkin wrote:
> The used approach actually cannot prevent new encoder interrupt to
> appear, because interrupt handler can execute in different thread, and
> in current implementation there is still race condition regarding this.

I don't understand what you mean with 'interrupt handler can execute in
different thread'. Can you elaborate?

Note that I do think that this change makes sense, but I do like to have a
better explanation.

Regards,

	Hans

> Also from practice the code with this change seems to work as stable as
> before.
> 
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> index b9b61b9..30e09d9 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> @@ -703,9 +703,7 @@ static int solo_ring_thread(void *data)
>  
>  		if (timeout == -ERESTARTSYS || kthread_should_stop())
>  			break;
> -		solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
>  		solo_handle_ring(solo_dev);
> -		solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
>  		try_to_freeze();
>  	}
>  
> 

