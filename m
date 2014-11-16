Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaKPP4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 10:56:20 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:56358 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaKPP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 10:56:19 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1415722798-4894-1-git-send-email-xypron.glpk@gmx.de>
References: <CAKgNAkj_Bs7d=YV_CFLNHuJacbp_+Kk_Jux_FdiBSuUAsObA=Q@mail.gmail.com>
 <1415722798-4894-1-git-send-email-xypron.glpk@gmx.de>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 16 Nov 2014 16:55:58 +0100
Message-ID: <CAKgNAkgVUeekKZjyTsjWgkXfv_u72T_ms7qofSJ_omqhfExfCw@mail.gmail.com>
Subject: Re: [PATCH] getrandom.2: treatment of interrupts
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heinrich,

On Tue, Nov 11, 2014 at 5:19 PM, Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> || pick 0ef180e getrandom.2: Add a sentence to clarify the default behavior...
> || pick 62342ef getrandom.2: Reword GRND_NONBLOCK description
> || pick 0c90d3d getrandom.2: Reword GRND_RANDOM description
> These patches look ok.
>
> || FIXME is the following paragraph correct?
> Paragraph is correct. FIXME removed.
>
> The appended patch removed two FIXMEs.
> The description of the treatment of interrupts is updated.
>
> || FIXME Here, I think there needs to be an opening paragraph ...
> The description of the treatment of interupts has been reworked.
> FIXME removed.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  man2/getrandom.2 | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/man2/getrandom.2 b/man2/getrandom.2
> index 59ebbe0..5bf57b7 100644
> --- a/man2/getrandom.2
> +++ b/man2/getrandom.2
> @@ -55,7 +55,6 @@ Therefore
>  should not be used for Monte Carlo simulations or other
>  programs/algorithms which are doing probabilistic sampling.
>
> -.\" FIXME is the following paragraph correct?
>  By default,
>  .BR getrandom ()
>  draws entropy from the
> @@ -157,10 +156,14 @@ was introduced in version 3.17 of the Linux kernel.
>  This system call is Linux-specific.
>  .SH NOTES
>  .SS Interruption by a signal handler
> -.\" FIXME Here, I think there needs to be an opening paragraph that describes
> -.\" the cases where getrandom() can block. This should cover the cases with
> -.\" GRND_RANDOM and without GRND_RANDOM. Reading the existing page, I am
> -.\" still not completely confident that I know what the cases are.
> +If a blocking call is interrupted by a signal
> +when reading from
> +.I /dev/random
> +.RB ( GRND_RANDOM
> +is set),
> +.B EINTR
> +will be returned.
> +.PP

What I was meaning with my FIXME was: please describe the various
cases where getrandom() can block, both with GRND_RANDOM and without
GRND_RANDOM. As I read the man page, I am not sure that I understand
which the cases are.

Thanks,

Michael



>  The reaction of
>  .BR getrandom ()
>  in case of an interruption of a blocking call by a signal
> @@ -182,14 +185,6 @@ will not return
>  .BR EINTR .
>  Instead, it will return all of the bytes that have been requested.
>  .PP
> -When reading from
> -.I /dev/random
> -.RB ( GRND_RANDOM
> -is set)
> -these guarantees do
> -.I not
> -apply.
> -.PP
>  Calling
>  .BR getrandom ()
>  to read
> --
> 2.1.1
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
