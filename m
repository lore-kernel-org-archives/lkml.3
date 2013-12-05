Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3LENJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:09:34 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:34239 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab3LENJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:09:33 -0500
Date: Thu, 5 Dec 2013 10:09:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf trace: Fix crash on RHEL6
Message-ID: <20131205130924.GA10333@ghostprotocols.net>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
 <1386211302-31303-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386211302-31303-3-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 04, 2013 at 07:41:40PM -0700, David Ahern escreveu:
> Signed-off-by: David Ahern <dsahern@gmail.com>

What would make no fields to be present if tp_format is not NULL, i.e.
if the /format file was successfully parsed?

- Arnaldo

> ---
>  tools/perf/builtin-trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index a7aa771a98e6..8f47eaae2f34 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -1455,7 +1455,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
>  {
>  	size_t printed = 0;
>  
> -	if (sc->tp_format != NULL) {
> +	if ((sc->tp_format != NULL) && (sc->tp_format->format.fields != NULL)) {
>  		struct format_field *field;
>  		u8 bit = 1;
>  		struct syscall_arg arg = {
> -- 
> 1.8.3.4 (Apple Git-47)
