Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaK0Gta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:49:30 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:51311 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaK0Gt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
Date: Thu, 27 Nov 2014 12:19:26 +0530
Message-ID: <CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first example
From: Srikanth Thokala <sriku.linux@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikanth Thokala <sriku.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kindly review the patch.

Thanks
Srikanth

On Tue, Nov 18, 2014 at 10:09 AM, Srikanth Thokala
<sriku.linux@gmail.com> wrote:
> In the first example, the loads into 'x' and 'y' on CPU 2 doesn't
> match the sequence of events described below it.  To match the
> sequence of events, the values of 'A' and 'B' should be loaded
> into 'x' and 'y' respectively.
>
> Signed-off-by: Srikanth Thokala <sriku.linux@gmail.com>
> ---
>  Documentation/memory-barriers.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 22a969c..2770bce 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
>         CPU 1           CPU 2
>         =============== ===============
>         { A == 1; B == 2 }
> -       A = 3;          x = B;
> -       B = 4;          y = A;
> +       A = 3;          x = A;
> +       B = 4;          y = B;
>
>  The set of accesses as seen by the memory system in the middle can be arranged
>  in 24 different combinations:
> --
> 1.9.1
>
