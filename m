Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaDNKGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:06:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58631 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaDNKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:06:20 -0400
Message-ID: <1397468521.9258.28.camel@pasglop>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Mon, 14 Apr 2014 19:42:01 +1000
In-Reply-To: <1397416959.1555.30.camel@vger.seibold.net>
References: <1397416959.1555.30.camel@vger.seibold.net>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041410-0260-0000-0000-000004B8E72B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-13 at 21:22 +0200, Stefani Seibold wrote:
> When executing a kexec kernel on a PowerPC board the new started kernel
> will not find already enumerated USB devices due a missing reset on the
> USB bus.
> 
> As a work around a
> 
> echo 1 >/sys/bus/pci/drivers/[ex]hci-pci/BUS-ADDRESS-OF-THE-HCD/reset
> 
> will solve this. But this is far from beauty.
> 
> My latest kernel without this issue was for EHCI kernel 2.6.39 and for
> XHCI kernel 3.4, but i have no idea when exactly this behavior was
> introduced.
> 
> For X86 all is fine.

I don't know about EHCI specifically but this is a known issue with
XHCI, I observe similar issues on other powerpc platforms (servers)
and this isn't architecture specific (looks more like actualy xhc
implementation specific).

Thadeu Cascardo (on CC) has been the one investigating that on our side,
he might have more to add including patches.

Cheers,
Ben.


