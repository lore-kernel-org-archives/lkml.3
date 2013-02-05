Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3BESQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:16:40 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61264 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3BESQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:16:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: davinci: use request_threaded_irq() to fix deadlock
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        Thomas Gleixner <tglx@linuronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <50E44FEC.3080009@ti.com>
References: <1356120806-27964-1-git-send-email-m-karicheri2@ti.com> <20121222100803.88FCE3E0AD0@localhost> <50E44FEC.3080009@ti.com>
Date: Tue, 05 Feb 2013 17:13:33 +0000
Message-Id: <20130205171333.B4D483E0D17@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013 10:19:08 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 12/22/2012 05:08 AM, Grant Likely wrote:
> > On Fri, 21 Dec 2012 15:13:26 -0500, Murali Karicheri<m-karicheri2@ti.com>  wrote:
> >> With RT pre-empt patch applied to Linux kernel, the irq handler will be
> >> force converted to an irq thread. spi driver can get back to back messages
> >> from the slave device. In such cases, IRQ thread doesn't get a chance to
> >> run to read the slave data. Hence the irq handler must be run in hard irq
> >> context to read/write data from slave device. Otherwise, the kernel goes
> >> into a deadlock. This patch fixes this issue when PREEMPT_RT_FULL is
> >> enabled in the kernel. A dummy thread function is provided to satisfy the
> >> request_threaded_irq() API. Passing a NULL for function also causes the
> >> irq handler to be executed in the thread context.
> >>
> >> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> > Thomas, would you mind taking a look at this for me. My gut feel is that
> > this is the wrong way to solve the problem that Murali is having and
> > that it really just hacks something that works.
> Grant,
> 
> Thanks for reviewing this. As per the RT patch, all of the IRQ handlers 
> will be converted to thread by brute force. This breaks the SPI driver 
> since the data is overwritten with back to back irq as thread is not 
> getting a chance to read the word before next irq happens.  What my 
> patch does is to keep the functionality as before by using a new irq 
> API. So though this is not the best solution, this solves the problem 
> and give an opportunity for improvement by splitting this into two part 
> to handle the irq. But I am not convinced if this is really needed.

Okay. Applied, thanks.

g.
