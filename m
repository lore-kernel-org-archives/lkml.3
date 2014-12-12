Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966442AbaLLLjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:39:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:34195 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965873AbaLLLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:39:39 -0500
Date: Fri, 12 Dec 2014 12:39:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 4/4] acpi: ioapic: Respect the resource flags
In-Reply-To: <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412121147230.16494@nanos>
References: <20141211191853.613107396@linutronix.de> <20141211193112.813391696@linutronix.de> <CAE9FiQV4jArUDGuhb3o2BhiVGcGxSXhADU+5=NsdqJGQOo2oJQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Yinghai Lu wrote:
> On Thu, Dec 11, 2014 at 11:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> Also please check attached following patch that will move code to acpi core.

Fun. I came up with more or less the same patch (properly split into
seperate patches) yesterday morning, but decided to keep it out of the
series because it looked ugly.

We really should have something like this:

struct translated_rescource {
       struct resource 	    res;
       u64    	       	    offset;
};

and a proper acpi function for it. Adding the offset could be done
there as well. That will simplify the magic in x86/pci/acpi as you
only have to deal with a single storage place.

Thanks,

	tglx




