Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3GNFuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 01:50:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49493 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3GNFui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 01:50:38 -0400
Message-ID: <51E2E485.9090902@gmail.com>
Date: Sun, 14 Jul 2013 13:48:53 -0400
From: Dong Fang <yp.fangdong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dong Fang <yp.fangdong@gmail.com>
CC: viro@zeniv.linux.org.uk, nyc@holomorphy.com, fweisbec@gmail.com,
        dhowells@redhat.com, mchehab@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kprobes: fix compiler warning
References: <1372689999-30921-1-git-send-email-yp.fangdong@gmail.com>
In-Reply-To: <1372689999-30921-1-git-send-email-yp.fangdong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 10:46 AM, Dong Fang wrote:
> Fix the following compiler warning of uninitialized variable
>
> kernel/kprobes.c: In function 'register_kprobe':
> kernel/kprobes.c:1493: warning: 'probed_mod' may be used uninitialized in this function
>
> Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
> ---
>   kernel/kprobes.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index bddf3b2..7a5b2b1 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1490,7 +1490,7 @@ int __kprobes register_kprobe(struct kprobe *p)
>   {
>   	int ret;
>   	struct kprobe *old_p;
> -	struct module *probed_mod;
> +	struct module *probed_mod = NULL;
>   	kprobe_opcode_t *addr;
>
>   	/* Adjust probe address from symbol */
>
can anybody take a look at this patch and give me some feedback? thx
