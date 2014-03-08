Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaCHTOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:14:37 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58301 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbaCHTOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:14:36 -0500
Message-ID: <1394306073.32104.4.camel@x220>
Subject: Re: [PATCH 4/4] raid6: Add severity levels to raid6 initialization
 messages
From: Paul Bolle <pebolle@tiscali.nl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ken Steele <ken@tilera.com>, Nicolas Pitre <nico@linaro.org>
Date: Sat, 08 Mar 2014 20:14:33 +0100
In-Reply-To: <16072d10240583debb7d303136c507c32c4d4b5d.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
	 <16072d10240583debb7d303136c507c32c4d4b5d.1394304585.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2014 19:14:34.0008 (UTC) FILETIME=[A3BD0180:01CF3B02]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 10:58 -0800, Andy Lutomirski wrote:
> Some of them are errors; some are not.  Annotate them accordingly.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  lib/raid6/algos.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> [...]
> @@ -194,7 +195,7 @@ int __init raid6_select_algo(void)
>  	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
>  
>  	if (!syndromes) {
> -		printk("raid6: Yikes!  No memory available.\n");
> +		printk(KERN_ERR "raid6: Yikes!  No memory available.\n");
>  		return -ENOMEM;
>  	}
>  

Does __get_free_pages() print and error (or similar) when it fails? If
so, this printk() could be dropped, couldn't it?


Paul Bolle

