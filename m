Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3A1WRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:17:47 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:59512 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab3A1WRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:17:45 -0500
Message-ID: <5106F8F6.80101@ilyx.ru>
Date: Tue, 29 Jan 2013 02:17:26 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>
Subject: Re: [PATCH] n_tty: Unthrottle tty when flushing read buffer
References: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
In-Reply-To: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.01.2013 2:36, Karthik Manamcheri wrote:
> When the tty input buffer is full and thereby throttled,
> flushing/resetting the read buffer should unthrottle to allow more
> data to be received.
> 
> Signed-off-by: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
> ---
>  drivers/tty/n_tty.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 19083efa2314660b25e0fb5bc793af6fb7e9af57..d5cea3bb01eaeec61b577de6c58a8000412c0c37 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -229,6 +229,8 @@ static void reset_buffer_flags(struct tty_struct *tty)
>  	ldata->canon_head = ldata->canon_data = ldata->erasing = 0;
>  	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
>  	n_tty_set_room(tty);
> +
> +	check_unthrottle(tty);
>  }
>  
>  /**
> 

It's revert - tty: fix "IRQ45: nobody cared".
commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

Please, read these for this subject:
https://lkml.org/lkml/2012/11/27/440
https://lkml.org/lkml/2012/11/21/568

https://lkml.org/lkml/2012/11/22/686

It's already fixed in the:
commit a1bf9584429d61b7096f93ae09325e1ba538e9e8
tty: Add driver unthrottle in ioctl(...,TCFLSH,..).

