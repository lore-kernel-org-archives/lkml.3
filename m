Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaH3NGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 09:06:47 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63798 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaH3NGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 09:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAMym5wtmgsAUP6C-eYgMKJcbiPCUVJ-jZW0PFtv4Mwvr3S9jdw@mail.gmail.com>
References: <1409164021-2136-1-git-send-email-chris.j.arges@canonical.com>
	<CAMym5wtmgsAUP6C-eYgMKJcbiPCUVJ-jZW0PFtv4Mwvr3S9jdw@mail.gmail.com>
Date: Sat, 30 Aug 2014 22:06:45 +0900
Message-ID: <CAMym5wtXPOd+5FQiXatpnM-TLkyabA=ZV6aj=wxe-=Bn83B5qw@mail.gmail.com>
Subject: Re: [PATCH] ktest: add ability to skip during BISECT_MANUAL
From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Sorry for late reply.

2014-08-28 3:26 GMT+09:00 Chris J Arges <chris.j.arges@canonical.com>:

> When doing a manual bisect, a build can fail or a test can be inconclusive.
> In these cases it would be helpful to be able to skip the test entirely.
>
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>

It look good to me.

Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>

Thanks,
Satoru

>
> ---
>  tools/testing/ktest/ktest.pl | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index 55ab700..72010f4 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -2336,15 +2336,17 @@ sub success {
>
>  sub answer_bisect {
>      for (;;) {
> -       doprint "Pass or fail? [p/f]";
> +       doprint "Pass, fail, or skip? [p/f/s]";
>         my $ans = <STDIN>;
>         chomp $ans;
>         if ($ans eq "p" || $ans eq "P") {
>             return 1;
>         } elsif ($ans eq "f" || $ans eq "F") {
>             return 0;
> +       } elsif ($ans eq "s" || $ans eq "S") {
> +           return -1;
>         } else {
> -           print "Please answer 'P' or 'F'\n";
> +           print "Please answer 'p', 'f', or 's'\n";
>         }
>      }
>  }
> --
> 1.9.1
>
