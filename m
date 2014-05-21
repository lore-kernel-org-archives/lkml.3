Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaEUVl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:41:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:45072 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaEUVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:41:51 -0400
Date: Thu, 22 May 2014 06:41:57 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 1/3] timerfd: Implement show_fdinfo method
In-Reply-To: <20140428213301.304637183@openvz.org>
Message-ID: <alpine.DEB.2.02.1405220641240.9695@ionos.tec.linutronix.de>
References: <20140428212517.200264067@openvz.org> <20140428213301.304637183@openvz.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:
>  
> +static int timerfd_show(struct seq_file *m, struct file *file)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	struct itimerspec t;
> +
> +	spin_lock_irq(&ctx->wqh.lock);
> +	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
> +	t.it_interval = ktime_to_timespec(ctx->tintv);
> +	spin_unlock_irq(&ctx->wqh.lock);
> +
> +	return seq_printf(m,
> +			  "clockid: %d\n"
> +			  "ticks: %llu\n"
> +			  "settime flags: 0%o\n"
> +			  "it_value: (%llu, %llu)\n"
> +			  "it_interval: (%llu, %llu)\n",
> +			  ctx->clockid, (unsigned long long)ctx->ticks,
> +			  ctx->settime_flags,
> +			  (unsigned long long)t.it_value.tv_sec,
> +			  (unsigned long long)t.it_value.tv_nsec,
> +			  (unsigned long long)t.it_interval.tv_sec,
> +			  (unsigned long long)t.it_interval.tv_nsec);
> +}

Shouldn't this depend on CONFIG_PROCFS?

>  static const struct file_operations timerfd_fops = {
>  	.release	= timerfd_release,
>  	.poll		= timerfd_poll,
>  	.read		= timerfd_read,
>  	.llseek		= noop_llseek,
> +	.show_fdinfo	= timerfd_show,
>  };
>  
>  static int timerfd_fget(int fd, struct fd *p)
> 
> 
