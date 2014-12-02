Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaLBLQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:16:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:47365 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaLBLQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:16:46 -0500
Date: Tue, 2 Dec 2014 12:16:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <sasha.levin@oracle.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] time: settimeofday: validate the values of tv fomr
 user
In-Reply-To: <1417493050-13594-5-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.DEB.2.11.1412021209020.3961@nanos>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com> <1417493050-13594-5-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014, Sasha Levin wrote:

> An unvalidated user input is multiplied by a constant, which can result in
> an undefined behaviour for large values. While this is validated later,
> we should avoid triggering undefined behaviour.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/time/time.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index 9ec4fa5..6f53df7 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -200,6 +200,10 @@ SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
>  	if (tv) {
>  		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
>  			return -EFAULT;
> +
> +		if (user_tv.tv_usec > USEC_PER_SEC || user_tv.tv_usec < 0)
> +			return -EINVAL;

We should create timeval_valid() for this with the same logic as
timespec_valid().

Thanks,

	tglx

