Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaG1Ocz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:32:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaG1Ocx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:32:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: elevator.c:  Cleaning up missing null-terminate in conjunction with strncpy
References: <1406416541-8984-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 28 Jul 2014 10:32:37 -0400
In-Reply-To: <1406416541-8984-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sun, 27 Jul 2014 01:15:41 +0200")
Message-ID: <x49oaw9pn96.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> And set a string to be empty from the start.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  block/elevator.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/elevator.c b/block/elevator.c
> index 24c28b6..ad17774 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -118,7 +118,7 @@ static struct elevator_type *elevator_get(const char *name, bool try_loading)
>  	return e;
>  }
>  
> -static char chosen_elevator[ELV_NAME_MAX];
> +static char chosen_elevator[ELV_NAME_MAX] = "";
>  
>  static int __init elevator_setup(char *str)
>  {
> @@ -126,7 +126,7 @@ static int __init elevator_setup(char *str)
>  	 * Be backwards-compatible with previous kernels, so users
>  	 * won't get the wrong elevator.
>  	 */
> -	strncpy(chosen_elevator, str, sizeof(chosen_elevator) - 1);
> +	strlcpy(chosen_elevator, str, sizeof(chosen_elevator));
>  	return 1;
>  }

NACK.  bss is zeroed.
