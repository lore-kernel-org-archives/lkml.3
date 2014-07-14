Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaGNG4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:56:00 -0400
Received: from mxout5.netvision.net.il ([194.90.6.65]:60364 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaGNGzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:55:52 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2014 02:55:52 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <53C37B67.7000203@gmail.com>
Date: Mon, 14 Jul 2014 09:40:39 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xillybus: place 'else' on same line as '}'
References: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
In-reply-to: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for this.

And since I looked at the part in Codingstyle that deals with if-else, I 
found another few mistakes regarding braces around a single statement. 
The rules say, it turns out, that if one of the clauses in an if-else is 
longer than one statement, both clauses should be wrapped with braces. 
This rule is broken in lines 162, 536 and 613 of the same file.

To avoid possible conflicts, I'll wait for this patch to be applied, and 
submit my corrections after that.

Regards,
    Eli


On 14/07/14 06:07, Jeremiah Mahler wrote:
> Place 'else' on same line as closing brace '}' as per
> Documentation/CodingStyle.  Fixes 1 error found by checkpatch.pl.
>
> Signed-off-by: Jeremiah Mahler<jmmahler@gmail.com>
> ---
>   drivers/staging/xillybus/xillybus_core.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
> index ab6502c..7de4c11 100644
> --- a/drivers/staging/xillybus/xillybus_core.c
> +++ b/drivers/staging/xillybus/xillybus_core.c
> @@ -546,8 +546,7 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
>   			channel->rd_buffers = buffers;
>   			rc = xilly_get_dma_buffers(ep,&rd_alloc, buffers,
>   						   bufnum, bytebufsize);
> -		}
> -		else if (channelnum>  0) {
> +		} else if (channelnum>  0) {
>   			channel->num_wr_buffers = bufnum;
>
>   			channel->seekable = seekable;
>    

