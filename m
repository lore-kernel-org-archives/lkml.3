Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaL3PsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:48:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44575 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaL3PsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:48:13 -0500
Date: Tue, 30 Dec 2014 16:48:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/boot/early_serial_console: Remove unnecessary
 check
Message-ID: <20141230154808.GA21238@nazgul.tnic>
References: <1419946102-17175-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419946102-17175-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 07:28:22PM +0600, Alexander Kuleshov wrote:
> There is already the same check before.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---
>  arch/x86/boot/early_serial_console.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
> index 5df2869..62abcc8 100644
> --- a/arch/x86/boot/early_serial_console.c
> +++ b/arch/x86/boot/early_serial_console.c
> @@ -74,8 +74,7 @@ static void parse_earlyprintk(void)
>  			static const int bases[] = { 0x3f8, 0x2f8 };
>  			int idx = 0;
>  
> -			if (!strncmp(arg + pos, "ttyS", 4))
> -				pos += 4;

You might need a comment to explain the advancing of pos to people who
look at this in the future, i.e. something like

			/* += strlen("ttyS"); */
			pos += 4;
>  
>  			if (arg[pos++] == '1')
>  				idx = 1;

-- 
Regards/Gruss,
    Boris.
--
