Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaFPQCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:02:47 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54211 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:02:46 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 16 Jun 2014 09:02:38 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] lib.c: skip --param parameters
Message-ID: <20140616160238.GA2746@jtriplet-mobl1>
References: <1402915386-28210-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402915386-28210-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 01:43:06PM +0300, Andy Shevchenko wrote:
> Very dumb patch to just skip --param allow-store-data-races=0 introduced in
> newest Linux kernel buildsystem.
> 
> Actually the option is present in few GCC versions and probably should be
> handled properly.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

As far as I can tell, this seems to only handle "--param arg"; however,
according to the thread on LKML, GCC handles --param=arg as well.  Could
you please handle that variant too?

>  lib.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib.c b/lib.c
> index bf3e91c..e56037b 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -673,6 +673,12 @@ static char **handle_version(char *arg, char **next)
>  	exit(0);
>  }
>  
> +static char **handle_param(char *arg, char **next)
> +{
> +	++next;
> +	return ++next;
> +}
> +
>  struct switches {
>  	const char *name;
>  	char **(*fn)(char *, char **);
> @@ -681,6 +687,7 @@ struct switches {
>  static char **handle_long_options(char *arg, char **next)
>  {
>  	static struct switches cmd[] = {
> +		{ "param", handle_param },
>  		{ "version", handle_version },
>  		{ NULL, NULL }
>  	};
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sparse" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
