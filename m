Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaFWTP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:15:27 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37468 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaFWTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:15:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lib: list_sort_test(): Add extra corruption check
Organization: D03
References: <1403308142-25897-1-git-send-email-linux@rasmusvillemoes.dk>
	<1403308142-25897-2-git-send-email-linux@rasmusvillemoes.dk>
X-Hashcash: 1:20:140623:artem.bityutskiy@linux.intel.com::zOl32YdoQmMuA0GU:0000000000000000000000000000001rq
X-Hashcash: 1:20:140623:david@fromorbit.com::HMW1SuhxVCR+KvxI:0000000000000000000000000000000000000000001W3p
X-Hashcash: 1:20:140623:linux-kernel@vger.kernel.org::zb04Bif0J57DdulX:00000000000000000000000000000000016EZ
X-Hashcash: 1:20:140623:don.mullis@gmail.com::daogXgVZfp96tx9K:000000000000000000000000000000000000000001dsi
Date: Mon, 23 Jun 2014 21:15:21 +0200
In-Reply-To: <1403308142-25897-2-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Sat, 21 Jun 2014 01:49:02 +0200")
Message-ID: <87lhsnqvxy.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> Add a check to make sure that the prev pointer of the list head points
> to the last element on the list.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/list_sort.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/lib/list_sort.c b/lib/list_sort.c
> index 291412a..832f525 100644
> --- a/lib/list_sort.c
> +++ b/lib/list_sort.c
> @@ -272,6 +272,11 @@ static int __init list_sort_test(void)
>  		}
>  		count++;
>  	}
> +	if (head->prev != cur) {

Scratch that, should be head.prev. Obviously I forgot TEST_LIST_SORT=y when
test-compiling. Anyway, I have a few other things I'd like to propose
for list_sort.c. Revised patches on their way; sorry for the noise.

Rasmus

