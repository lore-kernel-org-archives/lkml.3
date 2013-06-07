Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3FGWY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:24:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60651 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752999Ab3FGWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:24:57 -0400
Message-ID: <1370643896.2209.153.camel@joe-AO722>
Subject: Re: [PATCH 0/7] irq: fix checkpatch errors and warnings
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com
Date: Fri, 07 Jun 2013 15:24:56 -0700
In-Reply-To: <alpine.LFD.2.02.1306072208420.24812@ionos>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
	 <alpine.LFD.2.02.1306072208420.24812@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 22:42 +0200, Thomas Gleixner wrote:
> On Thu, 6 Jun 2013, Kefeng Wang wrote:
> 
> > Fix all the checkpath errors in kernel/irq dir, and some warnings
> > also fixed.
> 
> Sorry, I'm not really interested in this kind of patches. To be
> honest, it would be way more exciting if you had taught checkpatch to
> actually fix the missing space after the comma.

Yup.  Kefeng, if you want to take that up,
I'd be happy to help/guide you.

> Aside of that your mechanical fixups are mostly making the code worse
> to read. Just a few examples:
> 
> --- linux-2.6.orig/kernel/irq/chip.c
[]
>         struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
>                                                      IRQ_GET_DESC_CHECK_GLOBAL);
> 
> Aligning the first arguments of the first and the second line makes it
> way simpler to read.

or maybe use

	struct irq_desc *desc =
		irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);

and satisfy 80 cols too.

Existing uses that exceed the 80 column text limit shouldn't
be changed without making other useful changes at the same
time.  Make 80 column changes as part of a larger patch set,

> --- linux-2.6.orig/kernel/irq/handle.c
[]
> @@ -47,7 +47,7 @@ static void warn_no_thread(unsigned int 

> -       printk(KERN_WARNING "IRQ %d device %s returned IRQ_WAKE_THREAD "
> +       pr_warn("IRQ %d device %s returned IRQ_WAKE_THREAD "
>                "but no thread function available.", irq, action->name);

It'd be useful to add a terminating \n though to avoid
interleaving by other thread pr_cont/naked printks.

> The checkpatch warning is to prevent new code to use the old style
> printk format, but it's not intended to force that on existing code.

Yup, and checkpatch will never be a perfect tool.

> Please sit down and read and understand the code and try to find real
> issues which cannot be detected and solved by scripts and
> tools. That's what's kernel hacking is about. You are not becoming a
> kernel developer by running tools and blindly fixing the complaints of
> the tools. You have to understand the code and you have to learn to
> judge the output of tools.

Quite right.

Maybe add something like it to SubmittingPatches in
Section 2 ala:

5) "Don't be a checkpatch monkey - How not to write patches"


