Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3GAOq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:46:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58773 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3GAOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:46:26 -0400
Message-ID: <51D1962C.5030608@gmail.com>
Date: Mon, 01 Jul 2013 10:46:04 -0400
From: Dong Fang <yp.fangdong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dong Fang <yp.fangdong@gmail.com>
CC: viro@zeniv.linux.org.uk, nyc@holomorphy.com, fweisbec@gmail.com,
        dhowells@redhat.com, mchehab@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: fix compiler warning
References: <1372689218-30703-1-git-send-email-yp.fangdong@gmail.com>
In-Reply-To: <1372689218-30703-1-git-send-email-yp.fangdong@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 10:33 AM, Dong Fang wrote:
> Fix the following compiler warning of uninitialized variable
>
> kernel/kprobes.c: In function ‘register_kprobe’:
> kernel/kprobes.c:1493: warning: ‘probed_mod’ may be used uninitialized in this function
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
this patch seems have some problem, i will send a new patch later, thx
