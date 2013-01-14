Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3ANRiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:38:14 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53927 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3ANRiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:38:13 -0500
MIME-Version: 1.0
In-Reply-To: <1358182250-89669-1-git-send-email-dsahern@gmail.com>
References: <1358182250-89669-1-git-send-email-dsahern@gmail.com>
Date: Mon, 14 Jan 2013 12:38:13 -0500
Message-ID: <CAHdPZaPBd8evQsHbtNaToGnqSmUyuE_ZNNnPDLGCYD4i8p+sUA@mail.gmail.com>
Subject: Re: [PATCH] perf: dso_load - move name malloc to when needed
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:50 AM, David Ahern <dsahern@gmail.com> wrote:
> memory is currently leaked on some paths.

you are missing a signoff.

> ---
>  tools/perf/util/symbol.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 61edfd0..e9c0c3a 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -775,10 +775,6 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>         else
>                 machine = NULL;
>
> -       name = malloc(PATH_MAX);
> -       if (!name)
> -               return -1;
> -
>         dso->adjust_symbols = 0;
>
>         if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
> @@ -802,6 +798,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>         if (machine)
>                 root_dir = machine->root_dir;
>
> +       name = malloc(PATH_MAX);
> +       if (!name)
> +               return -1;
> +
>         /* Iterate over candidate debug images.
>          * Keep track of "interesting" ones (those which have a symtab, dynsym,
>          * and/or opd section) for processing.
> --
> 1.7.10.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
