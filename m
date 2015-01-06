Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbbAFGeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:34:10 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48151 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbAFGeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:34:07 -0500
Message-ID: <54AB81DC.2000308@gmail.com>
Date: Tue, 06 Jan 2015 07:34:04 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] adjtimex.2: Update return value of adjtimex
References: <1419426040-16090-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1419426040-16090-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Masanari Iida,

On 12/24/2014 02:00 PM, Masanari Iida wrote:
> This patch update return value of adjtimex man page.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  man2/adjtimex.2 | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
> index eb3fda1..f2a8b8c 100644
> --- a/man2/adjtimex.2
> +++ b/man2/adjtimex.2
> @@ -109,12 +109,13 @@ returns the clock state:
>  .PP
>  .in +4n
>  .nf
> -#define TIME_OK   0 /* clock synchronized */
> -#define TIME_INS  1 /* insert leap second */
> -#define TIME_DEL  2 /* delete leap second */
> -#define TIME_OOP  3 /* leap second in progress */
> -#define TIME_WAIT 4 /* leap second has occurred */
> -#define TIME_BAD  5 /* clock not synchronized */
> +#define TIME_OK    0 /* clock synchronized */
> +#define TIME_INS   1 /* insert leap second */
> +#define TIME_DEL   2 /* delete leap second */
> +#define TIME_OOP   3 /* leap second in progress */
> +#define TIME_WAIT  4 /* leap second has occurred */
> +#define TIME_ERROR 5 /* clock not synchronized */
> +#define TIME_BAD   TIME_ERROR /* bw compat */
>  .fi
>  .in
>  .PP

Thanks for your patch. Because of other recent changes to the page,
it does not apply, but I instead applied the patch below. Does
that look okay to you?

Thanks,

Michael

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 4b558b7..644e39b 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -305,8 +305,13 @@ Leap second in progress.
 .BR TIME_WAIT
 Leap second has occurred.
 .TP
-.BR TIME_BAD
+.BR TIME_ERROR
 Clock not synchronized.
+The symbolic name
+.B TIME_BAD
+is a synonym for
+.BR TIME_ERROR ,
+provided for backward comaptibility.
 .PP
 On failure,
 .BR adjtimex ()




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
