Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3JNCb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:31:29 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36696 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3JNCb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131013151729.GA4028@srcf.ucam.org>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
	<CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
	<1381421199.4248.2.camel@x230.lan>
	<CAMP44s04+_aP7KpVMTUjdNcRWMg6PC6HBaNhF_uhAHm=fhmTcw@mail.gmail.com>
	<20131013151729.GA4028@srcf.ucam.org>
Date: Sun, 13 Oct 2013 21:31:25 -0500
Message-ID: <CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "corentin.chary@gmail.com" <corentin.chary@gmail.com>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 10:17 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Oct 13, 2013 at 04:29:34AM -0500, Felipe Contreras wrote:
>
>> I don't see anything in acpi_ex_system_memory_space_handler() that
>> takes into consideration virtual addresses.
>
> The spec doesn't seem to constrain it to physical addresses (it just
> refers to "Control Methods read and write data to locations in address
> spaces (for example, System memory and System I/O)", so I'd lean towards
> changing the behaviour of acpica rather than adding virt_to_phys().

And I assume you are not going to do that. Isn't acpica code outside
of the scope of Linux kernel development? If not, how do I go about
adding that capability.

Also, I find it weird that this the first driver that needs this.

Finally, I'm much more interested on what happens next, because I want
to link this driver to the thermal framework, so when temperature gets
too high, the fan gets an increased speed, because right now it seems
it's always on low speed, temperature gets high, and instead the CPU
gets throttled, which is not desirable.

Maybe this driver should be added to the staging area.

-- 
Felipe Contreras
