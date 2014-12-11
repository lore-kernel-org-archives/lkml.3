Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124AbaLKQgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:36:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:58787 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436AbaLKQgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:36:47 -0500
Date: Thu, 11 Dec 2014 17:36:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function resource_to_addr()
 in arch/x86/pci/acpi.c
In-Reply-To: <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412111650270.13233@nanos>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com> <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org> <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com> <alpine.DEB.2.11.1412101820510.13233@nanos>
 <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Yinghai Lu wrote:
> On Wed, Dec 10, 2014 at 12:15 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> -       struct resource r = {
> >> -               .flags = 0
> >> -       };
> >> +       struct resource r;
> >>
> >> +       memset(&r, 0, sizeof(r));
> >
> > What's the point of this change? Both initialize r to 0. memset()
> > generates better code, but that's irrelevant for the problem at hand.
> 
> late there is
> 
> info->res[info->res_num] = r;
> 
> don't want the random pointer in r get copied.

Did you actually read what I wrote?

    	struct resource r = {
	       .flags = 0
	};

initializes r completely to 0. So how do you get a random pointer in r?

Thanks,

	tglx
