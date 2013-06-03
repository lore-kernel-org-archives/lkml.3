Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3FCFro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:47:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43889 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:47:29 -0400
Message-ID: <51AC2DED.90706@hitachi.com>
Date: Mon, 03 Jun 2013 14:47:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] kprobes: handle empty/invalid input to debugfs "enabled"
 file
References: <1370034910-16268-1-git-send-email-minipli@googlemail.com>
In-Reply-To: <1370034910-16268-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/01 6:15), Mathias Krause wrote:
> When writing invalid input to 'debug/kprobes/enabled' it'll silently
> be ignored. Even worse, when writing an empty string to this file,
> the outcome is purely random as the switch statement will make its
> decision based on the value of an uninitialized stack variable.

Oops, right.

> 
> Fix this by handling invalid/empty input as error returning -EINVAL.

Thanks!

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  kernel/kprobes.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3fed7f0..948b597 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2322,6 +2322,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
>  	if (copy_from_user(buf, user_buf, buf_size))
>  		return -EFAULT;
>  
> +	buf[buf_size] = '\0';
>  	switch (buf[0]) {
>  	case 'y':
>  	case 'Y':
> @@ -2333,6 +2334,8 @@ static ssize_t write_enabled_file_bool(struct file *file,
>  	case '0':
>  		disarm_all_kprobes();
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	return count;
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


