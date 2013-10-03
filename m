Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3JCXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:40:23 -0400
Received: from leo.clearchain.com ([199.73.29.74]:19725 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3JCXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:40:21 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 19:40:20 EDT
Date: Fri, 4 Oct 2013 09:33:57 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Ping Cheng <pinglinux@gmail.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, benjamin.tissoires@gmail.com,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH] input - input.h: Add a new switch event
Message-ID: <20131003233357.GB21255@yabbi.bne.redhat.com>
References: <1380839467-27264-1-git-send-email-pingc@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380839467-27264-1-git-send-email-pingc@wacom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Fri, 04 Oct 2013 09:02:38 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 03:31:07PM -0700, Ping Cheng wrote:
> One of Wacom's pen and touch capable models added a switch for
> users to turn on/off touch events. We need to report the state of
> this switch to userland. But, there is no existing switch event
> defined for this purpose. Luckily enough, there is a room for a
> new switch event.
> 
> Signed-off-by: Ping Cheng <pingc@wacom.com>
> ---
>  include/uapi/linux/input.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index d08abf9..d4097b0 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -855,6 +855,7 @@ struct input_keymap_entry {
>  #define SW_FRONT_PROXIMITY	0x0b  /* set = front proximity sensor active */
>  #define SW_ROTATE_LOCK		0x0c  /* set = rotate locked/disabled */
>  #define SW_LINEIN_INSERT	0x0d  /* set = inserted */
> +#define SW_TOUCH_ENABLED	0x0e  /* set = touch switch turned on (touch events off) */
>  #define SW_MAX			0x0f
>  #define SW_CNT			(SW_MAX+1)
>  
> -- 
> 1.8.1.2

Acked-by: Peter Hutterer <peter.hutterer@who-t.net> for the principle,
though I think SW_TOUCH would be enough, given that the switch already
communicates on/off.

Cheers,
   Peter


