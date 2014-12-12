Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbaLLHxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:53:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:33066 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaLLHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:53:24 -0500
Date: Fri, 12 Dec 2014 08:53:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
In-Reply-To: <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412120847400.16494@nanos>
References: <20141211191853.613107396@linutronix.de> <20141211193112.813391696@linutronix.de> <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Yinghai Lu wrote:
> On Thu, Dec 11, 2014 at 11:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > +static inline bool is_valid_mem_resource(struct resource *res)
> > +{
> > +       return !(res->flags & IORESOURCE_DISABLED) &&
> > +               (res->flags & IORESOURCE_MEM);
> > +}
> > +
> There is minor problem about mem pref handling, original code will ignore them.

Bah. I missed that in that well documented function...

> with this patch will let it follow through.
> 
> should change is_valid_mem_resource to is_valid_mem_nonpref_resource()...
> 
> +static inline bool is_valid_mem_nonpref_resource(struct resource *res)
>  {
>         return !(res->flags & IORESOURCE_DISABLED) &&
> -               (res->flags & IORESOURCE_MEM);
> +               (res->flags & IORESOURCE_MEM) &&
> +               !(res->flags & IORESOURCE_PREFETCH);
>  }

Unfortunately that does not help, because nothing sets the
IORESOURCE_PREFETCH flag. Will fix it proper.

I still have no explanation why the translation offset needs to be
applied here.

Thanks,

	tglx

