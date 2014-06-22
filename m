Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaFVQhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:37:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaFVQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:37:31 -0400
Date: Sun, 22 Jun 2014 18:37:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: disable console blanking by default
Message-ID: <20140622163728.GA4461@amd.pavel.ucw.cz>
References: <20140618092730.GD22226@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618092730.GD22226@mother.pipebreaker.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-18 11:27:31, Tomasz Torcz wrote:
> 
> >From ea7cf47e3230eda63aa6c46092719437f9bbae8e Mon Sep 17 00:00:00 2001
> From: Tomasz Torcz <tomek@pipebreaker.pl>
> Date: Wed, 18 Jun 2014 11:18:06 +0200
> Subject: [PATCH] vt: disable console blanking by default
> 
>   Remove default 10 minute blank interval. Instead: never blank by
>   default.
>   "Screensaving" is no longer useful.  Today it only provides
>   obstacle when interacting with text console, especially through
>   remote lights-out management solutions.
> 
> Signed-off-by: Tomasz Torcz <tomek@pipebreaker.pl>

Dunno. You'll kill an LCD if you let same image there for too
long. Make it 10hours?

								Pavel

>  Documentation/kernel-parameters.txt | 4 ++--
>  drivers/tty/vt/vt.c                 | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6eaa9cd..0618648 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -710,8 +710,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  		For now, only VisioBraille is supported.
>  
>  	consoleblank=	[KNL] The console blank (screen saver) timeout in
> -			seconds. Defaults to 10*60 = 10mins. A value of 0
> -			disables the blank timer.
> +			seconds. A value of 0 disables the blank timer.
> +			Defaults to never blank.
>  
>  	coredump_filter=
>  			[KNL] Change the default value for
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 5e0f6ff..dbd4f23 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -176,7 +176,7 @@ int console_blanked;
>  
>  static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
>  static int vesa_off_interval;
> -static int blankinterval = 10*60;
> +static int blankinterval;
>  core_param(consoleblank, blankinterval, int, 0444);
>  
>  static DECLARE_WORK(console_work, console_callback);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
