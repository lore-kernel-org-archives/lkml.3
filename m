Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3BGO6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:58:36 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62017 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3BGO6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:58:31 -0500
Message-ID: <5113BF7C.5060201@suse.cz>
Date: Thu, 07 Feb 2013 15:51:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3 02/23] n_tty: Factor packet mode status change for
 reuse
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1360095638-6624-3-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-3-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 09:20 PM, Peter Hurley wrote:
> Factor the packet mode status change from n_tty_flush_buffer
> for use by follow-on patch.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index bf6958b..7194a33 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -237,6 +237,18 @@ static void reset_buffer_flags(struct tty_struct *tty)
>  	n_tty_set_room(tty);
>  }
>  
> +static void packet_mode_flush(struct tty_struct *tty)

I prefer naming functions according the name space they live in. In this
case n_tty_flush_packet_mode would be much better. Other than that this
one looks good.

-- 
js
suse labs
