Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3JNPxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:53:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47186 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3JNPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:53:00 -0400
Date: Mon, 14 Oct 2013 16:52:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "corentin.chary@gmail.com" <corentin.chary@gmail.com>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
Message-ID: <20131014155254.GB20187@srcf.ucam.org>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
 <CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
 <1381421199.4248.2.camel@x230.lan>
 <CAMP44s04+_aP7KpVMTUjdNcRWMg6PC6HBaNhF_uhAHm=fhmTcw@mail.gmail.com>
 <20131013151729.GA4028@srcf.ucam.org>
 <CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 09:31:25PM -0500, Felipe Contreras wrote:
> On Sun, Oct 13, 2013 at 10:17 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > The spec doesn't seem to constrain it to physical addresses (it just
> > refers to "Control Methods read and write data to locations in address
> > spaces (for example, System memory and System I/O)", so I'd lean towards
> > changing the behaviour of acpica rather than adding virt_to_phys().
> 
> And I assume you are not going to do that. Isn't acpica code outside
> of the scope of Linux kernel development? If not, how do I go about
> adding that capability.

I wasn't planning on it, no. Just write the code and submit it to 
linux-acpi, and Cc: Bob Moore.

> Also, I find it weird that this the first driver that needs this.

The normal way to do this would be for the ASL to just define a buffer 
within the argument, rather than assigning it to an operation region. I 
haven't seen anyone take this approach before.

> Finally, I'm much more interested on what happens next, because I want
> to link this driver to the thermal framework, so when temperature gets
> too high, the fan gets an increased speed, because right now it seems
> it's always on low speed, temperature gets high, and instead the CPU
> gets throttled, which is not desirable.

It wouldn't be appropriate to alter the firmware behaviour by default, 
but yeah, that's the kind of thing that the thermal framework exists to 
do.

> Maybe this driver should be added to the staging area.

I don't think you can easily register multiple drivers for the same WMI 
device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
