Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaDOK0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:26:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDOK0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:26:49 -0400
Message-ID: <534D0966.201@suse.cz>
Date: Tue, 15 Apr 2014 12:26:46 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Jean Delvare <jdelvare@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
References: <20140414145359.48b7337c@endymion.delvare> <20140414191143.GA26864@kroah.com> <20140414231254.392c0df8@endymion.delvare> <20140415045214.GA32541@kroah.com>
In-Reply-To: <20140415045214.GA32541@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 06:52, Greg KH wrote:
> On Mon, Apr 14, 2014 at 11:12:54PM +0200, Jean Delvare wrote:
>> I'm very fine with USB drivers being architecture-agnostic. They really
>> are. But in practice a lot of PCI and platform drivers are only useful
>> of one architecture, of a few ones at best.
> 
> Why would PCI devices only be useful on one architecture?  PCI works on
> almost all arches that Linux supports, if it's a PCI card, it could be
> on any of those processors.  If it's a mini-pci, the chances are less,
> but still quite possible.

"PCI device" does not necessarily imply any of the PCI/PCIe form
factors. Looking at my desktop machine, neither the integrated graphics
core nor the Intel Management Engine thing are cards that I could plug
into an ARM router with a PCI slot. So the i915 and mei drivers are
properly annotated with 'depends on X86' and one is not bothered with
the prompts when building a kernel for an ARM router.


> Yes, it's a pain for distros, and yes, it would be nice if people wrote
> better Kconfig help text.  Pushing back on that is the key here.  If you
> see new drivers show up that you don't know where they work on, ask the
> developers and make up patches.

Better help texts would be nice, but what would really help is some
machine-readable annotation. 'depends on <arch/mach> || COMPILE_TEST' is
already available, so why not use it.

Michal
