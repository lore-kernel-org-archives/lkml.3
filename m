Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JFWrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 18:47:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40622 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3JFWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 18:47:35 -0400
Date: Sun, 6 Oct 2013 23:41:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Subject: Re: [RFC] ARM: kernel: irq: Simplify allocation of stack frame
Message-ID: <20131006224150.GA25647@n2100.arm.linux.org.uk>
References: <1381098649-21417-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381098649-21417-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 05:30:47PM -0500, Joel Fernandes wrote:
> On receiving IRQ exception in SVC mode, all the SVC mode registers are saved
> onto the stack very early on.
> 
> The stack frame allocation code for IRQ entry during SVC mode (svc_entry) is
> hard to read as 4-less is allocated initially only to be allocated later
> implicity using the mov r3, [sp, #-4]! instruction. We make code easier to read
> by allocating the 4 bytes on the stack frame in the beginning itself and remove
> all instances where 4 bytes is adjusted.

You omit to say that this results in saving one additional register
unnecessarily in the stmia.  We could use a stmib there instead which
would avoid that issue while keeping the rest of the change.
