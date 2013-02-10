Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3BJOrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:47:25 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40659 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755566Ab3BJOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:47:24 -0500
Date: Sun, 10 Feb 2013 09:47:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Otavio Salvador <otavio@ossystems.com.br>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.8 broken for MacBookAir5,1
In-Reply-To: <CAP9ODKr2gomJR6Zrwc41ddhxn3nkFYtTLL-_xhbdRKN=n-A_+w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1302100946040.29460-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2013, Otavio Salvador wrote:

> Hello,
> 
> On Sat, Jan 12, 2013 at 8:41 PM, Otavio Salvador
> <otavio@ossystems.com.br> wrote:
> > Today I tried to update my kernel from 3.7.2 to 3.8-rc3 and I had no
> > success; I used localmodconfig to generate the .config for my machine
> > but keyboard does not work.
> >
> > Using same generated .config with 3.7.2 works fine.
> >
> > Anyone has a clue about?
> 
> I finally found time to do a bisect and I found:
> 
> commit adfa79d1c06a32650332930ca4c488ca570b3407
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Thu Nov 1 11:13:04 2012 -0400
> 
>     USB: EHCI: make ehci-pci a separate driver
> 
>     This patch (as1625) splits the PCI portion of ehci-hcd out into its
>     own separate driver module, called ehci-pci.  Consistently with the
>     current practice, the decision whether to build this module is not
>     user-configurable.  If EHCI and PCI are enabled then the module will
>     be built, always.
> 
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     CC: Felipe Balbi <balbi@ti.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> As the problem start.
> 
> I do have EHCI and PCI enabled so it should be working. Any clue about
> why it breaks it?

Perhaps your system is not loading the new ehci-pci kernel module.

Alan Stern

