Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3E3PHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:07:04 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40625 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3E3PG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:06:58 -0400
Date: Thu, 30 May 2013 23:06:36 +0800
From: Wang YanQing <udknight@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Greg KH <gregkh@linuxfoundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: parisc: kernel: using strlcpy() instead of strcpy()
Message-ID: <20130530150636.GA2121@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Chen Gang <gang.chen@asianux.com>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Helge Deller <deller@gmx.de>, Greg KH <gregkh@linuxfoundation.org>,
	Parisc List <linux-parisc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux-Arch <linux-arch@vger.kernel.org>
References: <51A6A8F3.2030200@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A6A8F3.2030200@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:18:43AM +0800, Chen Gang wrote:
> 
> 'boot_args' is an input args, and 'boot_command_line' has a fix length.
> 
> So need use strlcpy() instead of strcpy() to avoid memory overflow.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/parisc/kernel/setup.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
> index 60c1ae6..7349a3f 100644
> --- a/arch/parisc/kernel/setup.c
> +++ b/arch/parisc/kernel/setup.c
> @@ -69,7 +69,8 @@ void __init setup_cmdline(char **cmdline_p)
>  		/* called from hpux boot loader */
>  		boot_command_line[0] = '\0';
>  	} else {
> -		strcpy(boot_command_line, (char *)__va(boot_args[1]));
> +		strlcpy(boot_command_line, (char *)__va(boot_args[1]),
> +			COMMAND_LINE_SIZE);

What about add 
boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
to protect the following another strcpy?

"
strcpy(command_line, boot_command_line);
"
>  
>  #ifdef CONFIG_BLK_DEV_INITRD
>  		if (boot_args[2] != 0) /* did palo pass us a ramdisk? */
> -- 
> 1.7.7.6
