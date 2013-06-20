Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3FTKns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:43:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48583 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3FTKnr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 20 Jun 2013 06:43:47 -0400
Message-Id: <51C2F8FD02000078000DF51C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 20 Jun 2013 11:43:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "John Stultz" <john.stultz@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/4] x86/xen: sync the wallclock when
 the system time is stepped
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
 <1371655523-15609-4-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1371655523-15609-4-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.06.13 at 17:25, David Vrabel <david.vrabel@citrix.com> wrote:
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -211,6 +211,26 @@ static int xen_set_wallclock(const struct timespec *now)
>  
>  	return HYPERVISOR_dom0_op(&op);
>  }
> + 
> +static int xen_clock_was_set_notify(struct notifier_block *nb, unsigned long unused,
> +				    void *priv)
> +{
> +       struct timespec now;
> +       int ret;

Unused variable.

Jan

> +
> +       /*
> +        * Set the Xen wallclock from Linux system time.
> +        */
> +       now = current_kernel_time();
> +       xen_set_wallclock(&now);
> +
> +       return NOTIFY_OK;
> +}
> +
> +static struct notifier_block xen_clock_was_set_notifier = {
> +	.notifier_call = xen_clock_was_set_notify,
> +};
> +
>  
>  static struct clocksource xen_clocksource __read_mostly = {
>  	.name = "xen",


