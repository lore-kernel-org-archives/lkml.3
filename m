Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaATTTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:19:15 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:51690 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaATTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:19:12 -0500
Date: Mon, 20 Jan 2014 11:19:08 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Eunbong Song <eunb.song@samsung.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: make more readable panic_nand_wait_ready()
 and nand_wait_ready()
Message-ID: <20140120191908.GK8919@ld-irv-0074>
References: <19226555.341201389136795005.JavaMail.weblogic@epml09>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19226555.341201389136795005.JavaMail.weblogic@epml09>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:19:56PM +0000, Eunbong Song wrote:
> 
> panic_nand_wait_ready() and nand_wait_ready() calls dev_ready() without checking if it exists.

There are many occasions where we call a function pointer without
(locally) checking that it is non-NULL. That is by design.

If you see a problem with this behavior, please fix this properly rather
than covering it up. This patch will just make faulty drivers spin for
20ms rather than hitting a bug. Instead, you should aim to fix buggy
drivers that call dev_ready() without assigning it; or even better,
defensively improve nand_base to detect those drivers which are
utilizing nand_command_lp() or nand_command() without assigning
dev_ready().

> This patch add check routine dev_ready() before run dev_ready()
> and this makes the code more readable

This patch does not make the code more readable, nor does it improve the
state of the original code much. Please solve and document a real
problem.

Thanks,
Brian
