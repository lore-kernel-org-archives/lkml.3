Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3FGJqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:46:12 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40228 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab3FGJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:46:11 -0400
Date: Fri, 7 Jun 2013 11:38:54 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-serial@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, Chanho Min <chanho.min@lge.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Subject: amba pl011: where to submit a fix for x86 builds
Message-ID: <20130607093854.GA3429@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
This is cc'd to $(get_maintainer.pl -f drivers/tty/serial/amba-pl011.c)
and x86 maintainers too.

While working on the pci-to-amba bridge driver (to be resubmitted in
the next days) I have to deal with the problem of pl011 not building,
after phys_to_page was introduced, by Chanho Min (Cc: here) in commit

   cb06ff1 ARM: PL011: Add support for Rx DMA buffer polling.

because x86 has no phys_to_page.

The fix I use is trivially this:

  -       sg_set_page(&sg->sg, phys_to_page(dma_addr),
  +       sg_set_page(&sg->sg, virt_to_page(sg->buf),

(virt_to_page is slower, but other sg_get_page() users do the same
and other solutions are more convoluted).

Shall I submit this to x86 with the pci-to-amba bridge series or to
arm/serial and then note the dependency when posting the bridge series?

thanks
/alessandro
