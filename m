Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3BUPqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:46:18 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34838 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab3BUPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:46:17 -0500
Date: Thu, 21 Feb 2013 17:46:12 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Patrik, Kluba" <pkluba@dension.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: bug: keep_bootcon and early printk together can lead to
 (invisible) kernel panic
Message-ID: <20130221154612.GA11617@blackmetal.musicnaut.iki.fi>
References: <20130221153717.31400a88.pkluba@dension.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221153717.31400a88.pkluba@dension.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 03:37:17PM +0100, Patrik, Kluba wrote:
> I had a silent lockup on one of our embedded system under development.
> It was not easy to track it down, so here's what I discovered, in case
> somebody runs into similar trouble.
> Using 'keep_bootcon' command line parameter, and enabling early printk
> can lead to a kernel panic. At least on MIPS, it does. The problem is
> that in arch/mips/kernel/early_printk.c everything is declared as
> __init and __initdata, so they are being freed, when the kernel
> frees .init.* sections. If 'keep_bootcon' is given, the early console
> does not get unregistered, and the entry in the console_drivers list
> can point (will, believe me) to garbage data. It's up to you to imagine
> the effects...

I also ran into this recently, this should fix it:

	http://marc.info/?l=linux-kernel&m=136062078931024&w=2

A.
