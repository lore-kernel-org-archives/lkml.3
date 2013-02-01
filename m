Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3BAJHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:07:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34981 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3BAJHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:07:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130129160342.28754.96853.stgit@localhost.localdomain>
References: <20130129160342.28754.96853.stgit@localhost.localdomain>
Date: Fri, 1 Feb 2013 10:07:06 +0100
X-Google-Sender-Auth: JYJF4BN_iv0zP8Dx1_xwqyGIq0g
Message-ID: <CAAxaTiOGUo092Fgigs2U0R7Ry0HPvLTFqvvANp8TMFJbY+KgLw@mail.gmail.com>
Subject: Re: [PATCH 2 2/2] coccicheck: Allow to show the executed command line
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Julia Lawall <Julia.Lawall@lip6.fr>, cocci@systeme.lip6.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 5:03 PM, Bernd Schubert
<bernd.schubert@itwm.fraunhofer.de> wrote:
> On my system one of the tests failed with
> "Fatal error: exception Failure("No OCaml compiler found! Install either ocamlopt or ocamlopt.opt")".
>
> Investigating such issues is easier if the executed command line is being shown.
>
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> CC: Julia Lawall <Julia.Lawall@lip6.fr>
> CC: Nicolas Palix <nicolas.palix@imag.fr>

Acked-by: Nicolas Palix <nicolas.palix@imag.fr>

> CC: cocci@systeme.lip6.fr
> CC: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/coccicheck |   28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index f8f15a2..85d3189 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -55,6 +55,14 @@ if [ "$ONLINE" = "0" ] ; then
>      echo ''
>  fi
>
> +run_cmd() {
> +       if [ $VERBOSE -ne 0 ] ; then
> +               echo "Running: $@"
> +       fi
> +       eval $@
> +}
> +
> +
>  coccinelle () {
>      COCCI="$1"
>
> @@ -100,15 +108,21 @@ coccinelle () {
>      fi
>
>      if [ "$MODE" = "chain" ] ; then
> -       $SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
> -       $SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
> -       $SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
> -       $SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
> +       run_cmd $SPATCH -D patch   \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
> +       run_cmd $SPATCH -D report  \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
> +       run_cmd $SPATCH -D context \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
> +       run_cmd $SPATCH -D org     \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
>      elif [ "$MODE" = "rep+ctxt" ] ; then
> -       $SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
> -       $SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
> +       run_cmd $SPATCH -D report  \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
> +       run_cmd $SPATCH -D context \
> +               $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
>      else
> -       $SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
> +       run_cmd $SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
>      fi
>
>  }
>



-- 
Nicolas Palix
