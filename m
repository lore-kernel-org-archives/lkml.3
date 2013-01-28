Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3A1VjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:39:08 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56653 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754267Ab3A1VjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:39:07 -0500
Message-ID: <1359409138.3301.6.camel@thor.lan>
Subject: Re: [PATCH] n_tty: Unthrottle tty when flushing read buffer
From: Peter Hurley <peter@hurleysoftware.com>
To: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>
Date: Mon, 28 Jan 2013 16:38:58 -0500
In-Reply-To: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
References: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Ilya Zykov]

Hi Karthik,

On Wed, 2013-01-23 at 16:36 -0600, Karthik Manamcheri wrote:
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

Although it's not really my place to NAK, the maintainership was
recently transitioned, so NAK.  See this kernel thread
http://www.gossamer-threads.com/lists/linux/kernel/1636154?do=post_view_threaded#1636154
for why.

See if this patch
http://www.gossamer-threads.com/lists/linux/kernel/1660788
works for you instead.

Regards,
Peter Hurley


