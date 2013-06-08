Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3FIB7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 21:59:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61359 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3FIB7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 21:59:45 -0400
Date: Sat, 08 Jun 2013 13:50:06 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] doc: avoid strncpy in accounting tool
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20130606024930.GA24279@www.outflux.net>
In-Reply-To: <20130606024930.GA24279@www.outflux.net> (from
	keescook@chromium.org on Wed Jun  5 21:49:30 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370717406.2776.83@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 09:49:30 PM, Kees Cook wrote:
> Avoid strncpy anti-pattern. Use strdup() instead, as already done for
> the logfile optarg.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Fix for -mm clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
> ---
>  Documentation/accounting/getdelays.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c  
> b/Documentation/accounting/getdelays.c
> index f8ebcde..1db89d3 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -272,7 +272,7 @@ int main(int argc, char *argv[])
>  	char *logfile = NULL;
>  	int loop = 0;
>  	int containerset = 0;
> -	char containerpath[1024];
> +	char *containerpath = NULL;
>  	int cfd = 0;
>  	int forking = 0;
>  	sigset_t sigset;
> @@ -299,7 +299,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'C':
>  			containerset = 1;
> -			strncpy(containerpath, optarg, strlen(optarg) +  
> 1);
> +			containerpath = strdup(optarg);

*boggle* That an elaborate way of doing a standard strcpy(), isn't it?

(Assuming free() being done by exit() is ok, and that somebody's going  
to be modifying this string so just keeping the pointer to optarg might  
make ps look weird...)

Acked-by: Rob Landley <rob@landley.net>

if Andrew hasn't grabbed it already (I'm days behind on email) please  
send through trivial@kernel.org.

Rob