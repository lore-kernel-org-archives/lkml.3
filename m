Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbaAaUqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:46:03 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50763 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaAaUqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:46:01 -0500
Date: Fri, 31 Jan 2014 12:45:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kamble, Nitin A" <nitin.a.kamble@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: fix a Kconfig dependency
In-Reply-To: <52EBE112.5010203@intel.com>
Message-ID: <alpine.DEB.2.02.1401311241080.27318@chino.kir.corp.google.com>
References: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com> <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com> <alpine.DEB.2.02.1401310223460.7183@chino.kir.corp.google.com> <52EBE112.5010203@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1829940620-1391201129=:27318"
Content-ID: <alpine.DEB.2.02.1401311245330.27318@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1829940620-1391201129=:27318
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1401311245331.27318@chino.kir.corp.google.com>

On Fri, 31 Jan 2014, Kamble, Nitin A wrote:

> > So, if this dependency is reasonable, it begs the question of why we have
> > CONFIG_GENERIC_IRQ_CHIP at all and shouldn't just make generic-chip.c
> > depend on CONFIG_IRQ_DOMAIN.
> Looking at the code there are cases where IRQ_DOMAIN functionality is used
> without using the GENERIC_IRQ_CHIP. So making generic-chip.c depend
> on CONFIG_IRQ_DOMAIN in the makefile will reduce the flexibility of using
> these config options separately.
> 

Acked-by: David Rientjes <rientjes@google.com>

Although the changelog should be updated since I get a couple problems 
when trying to enable CONFIG_GENERIC_IRQ_CHIP without CONFIG_IRQ_DOMAIN on 
Linus's latest tree:

kernel/irq/generic-chip.c:400:11: error: ‘irq_domain_xlate_onetwocell’ undeclared here (not in a function)
kernel/irq/generic-chip.c: In function ‘irq_gc_get_irq_data’:
kernel/irq/generic-chip.c:522:2: error: implicit declaration of function ‘irq_find_mapping’ [-Werror=implicit-function-declaration]
--531381512-1829940620-1391201129=:27318--
