Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab3LIENp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:13:45 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:7524 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab3LIENn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:13:43 -0500
Message-ID: <52A5437E.2030708@hp.com>
Date: Mon, 09 Dec 2013 12:13:50 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: Re: [PATCH 1/1] drivers/tty: Fix missed unlocks for tty_release
References: <1386559228-26880-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1386559228-26880-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found it was incorrect. So please IGNORE this patch.
Sorry for that.


On 12/09/2013 11:20 AM, Li, Zhen-Hua wrote:
> In function tty_release, there are two unlock not called while
> breaking from a while. This may cause problems.
> This patch fixed this problem , adding the two unlocks before
> break is called.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/tty/tty_io.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index c74a00a..d41b0da 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1777,9 +1777,11 @@ int tty_release(struct inode *inode, struct file *filp)
>   				do_sleep++;
>   			}
>   		}
> -		if (!do_sleep)
> +		if (!do_sleep) {
> +			tty_unlock_pair(tty, o_tty);
> +			mutex_unlock(&tty_mutex);
>   			break;
> -
> +		}
>   		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
>   				__func__, tty_name(tty, buf));
>   		tty_unlock_pair(tty, o_tty);
>

