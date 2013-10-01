Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3JAMZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab3JAMZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:25:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        axboe@kernel.dk, Jianpeng Ma <majianpeng@gmail.com>
Subject: Re: [PATCH 04/11] block: Return error code of elevator init function
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
	<1380572952-30729-5-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 Oct 2013 08:25:14 -0400
In-Reply-To: <1380572952-30729-5-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 30 Sep 2013 13:29:05 -0700")
Message-ID: <x49ioxhdvpx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> The error code was ignored, which I assume is a mistake.

Yeah, introduced in d50235b7bc3ee0a0427984d763ea7534149531b4, so I cc'd
Jianpeng Ma, though it looks pretty obvious.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> Cc: axboe@kernel.dk
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  block/elevator.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/block/elevator.c b/block/elevator.c
> index 2bcbd8c..6c2a8ee 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -184,7 +184,6 @@ static void elevator_release(struct kobject *kobj)
>  int elevator_init(struct request_queue *q, char *name)
>  {
>  	struct elevator_type *e = NULL;
> -	int err;
>  
>  	if (unlikely(q->elevator))
>  		return 0;
> @@ -222,8 +221,7 @@ int elevator_init(struct request_queue *q, char *name)
>  		}
>  	}
>  
> -	err = e->ops.elevator_init_fn(q, e);
> -	return 0;
> +	return e->ops.elevator_init_fn(q, e);
>  }
>  EXPORT_SYMBOL(elevator_init);
