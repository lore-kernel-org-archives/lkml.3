Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaG2G2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:28:00 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47089 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaG2G14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <1406383102-1128-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406383102-1128-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 29 Jul 2014 14:27:55 +0800
Message-ID: <CAMk6uB=OJycPttFDwhP=kc7R6dB16Sg=w4xXdmXjq3u+P3fb8Q@mail.gmail.com>
Subject: Re: [PATCH] arch: blackfin: kernel: setup.c: Cleaning up missing
 null-terminate in conjunction with strncpy
From: Steven Miao <realmz6@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Al Viro <viro@zeniv.linux.org.uk>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied! Thanks.

On Sat, Jul 26, 2014 at 9:58 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/blackfin/kernel/setup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
> index 4f424ae..ad82468 100644
> --- a/arch/blackfin/kernel/setup.c
> +++ b/arch/blackfin/kernel/setup.c
> @@ -1464,5 +1464,5 @@ void __init cmdline_init(const char *r0)
>  {
>         early_shadow_stamp();
>         if (r0)
> -               strncpy(command_line, r0, COMMAND_LINE_SIZE);
> +               strlcpy(command_line, r0, COMMAND_LINE_SIZE);
>  }
> --
> 1.7.10.4
>
