Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaJPFKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:10:14 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45888 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaJPFKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:10:12 -0400
Date: Thu, 16 Oct 2014 07:10:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 06/10] clocksource: Remove "weak" from
 clocksource_default_clock() declaration
Message-ID: <20141016051007.GB14640@gmail.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bhelgaas@google.com> wrote:

> kernel/time/jiffies.c provides a default clocksource_default_clock()
> definition explicitly marked "weak".  arch/s390 provides its own definition
> intended to override the default, but the "weak" attribute on the
> declaration applied to the s390 definition as well, so the linker chose one
> based on link order (see 10629d711ed7 ("PCI: Remove __weak annotation from
> pcibios_get_phb_of_node decl")).
> 
> Remove the "weak" attribute from the clocksource_default_clock()
> declaration so we always prefer a non-weak definition over the weak one,
> independent of link order.
> 
> Fixes: f1b82746c1e9 ("clocksource: Cleanup clocksource selection")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Daniel Lezcano <daniel.lezcano@linaro.org>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  include/linux/clocksource.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 653f0e2b6ca9..abcafaa20b86 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -287,7 +287,7 @@ extern struct clocksource* clocksource_get_next(void);
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
>  extern void clocksource_suspend(void);
>  extern void clocksource_resume(void);
> -extern struct clocksource * __init __weak clocksource_default_clock(void);
> +extern struct clocksource * __init clocksource_default_clock(void);
>  extern void clocksource_mark_unstable(struct clocksource *cs);

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
