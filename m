Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaAaK1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:27:08 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52997 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaAaK1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:27:06 -0500
Date: Fri, 31 Jan 2014 02:27:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: nitin.a.kamble@intel.com
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: fix a Kconfig dependency
In-Reply-To: <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com>
Message-ID: <alpine.DEB.2.02.1401310223460.7183@chino.kir.corp.google.com>
References: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com> <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, nitin.a.kamble@intel.com wrote:

> From: Nitin A Kamble <nitin.a.kamble@intel.com>
> 
> The generic_chip.c uses interfaces from irq_domain.c which is controlled by
> the IRQ_DOMAIN config option.
> 
> Add a select statement in the Kconfig to reflect this requirement.
> 
> Without this fix, the generic_chip.c compilation fails like this:
> 
> linux/kernel/irq/generic-chip.c:400:11:
>   error: 'irq_domain_xlate_onetwocell' undeclared here (not in a function)
> 

You're not specifying which config option you have enabled that selects 
CONFIG_GENERIC_IRQ_CHIP and does not select CONFIG_IRQ_DOMAIN, but it does 
look like there is a dependency here.

So, if this dependency is reasonable, it begs the question of why we have 
CONFIG_GENERIC_IRQ_CHIP at all and shouldn't just make generic-chip.c 
depend on CONFIG_IRQ_DOMAIN.
