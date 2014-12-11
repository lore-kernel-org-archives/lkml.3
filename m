Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaLKQ50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:57:26 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36498 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615AbaLKQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:57:25 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412111650270.13233@nanos>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
	<tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
	<CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
	<alpine.DEB.2.11.1412101820510.13233@nanos>
	<CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
	<alpine.DEB.2.11.1412111650270.13233@nanos>
Date: Thu, 11 Dec 2014 08:57:24 -0800
X-Google-Sender-Auth: adtnYP1JJ2w964j8J7n6zVABXiw
Message-ID: <CAE9FiQXr1E=n0PzUgjA7sHEH-G=7_JvUOjZ1Z=az_j_ttb6mNA@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function
 resource_to_addr() in arch/x86/pci/acpi.c
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 8:36 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 10 Dec 2014, Yinghai Lu wrote:
>> On Wed, Dec 10, 2014 at 12:15 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> -       struct resource r = {
>> >> -               .flags = 0
>> >> -       };
>> >> +       struct resource r;
>> >>
>> >> +       memset(&r, 0, sizeof(r));
>> >
>> > What's the point of this change? Both initialize r to 0. memset()
>> > generates better code, but that's irrelevant for the problem at hand.
>
> Did you actually read what I wrote?
>
>         struct resource r = {
>                .flags = 0
>         };
>
> initializes r completely to 0. So how do you get a random pointer in r?

ok, I get it now.

I was thinking that compiler will generate code like
    struct resource r;
    r.flags = 0;

Thanks

Yinghai
