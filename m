Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaLKAbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:31:25 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36424 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLKAbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412101820510.13233@nanos>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com>
	<tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org>
	<CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
	<alpine.DEB.2.11.1412101820510.13233@nanos>
Date: Wed, 10 Dec 2014 16:31:22 -0800
X-Google-Sender-Auth: 2umTv-Csg4p7ta7lM4hQqOnFpYc
Message-ID: <CAE9FiQW95VoJ35+KXOfV8eqFjSnhgkAqUmFWOKyKMwOAR_x7Kg@mail.gmail.com>
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

On Wed, Dec 10, 2014 at 12:15 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 9 Dec 2014, Yinghai Lu wrote:
>
> Can you please
>
> 1) Cut out the completely irrelevant information from your replies?
>    It's just annoying to scroll through hundreds of quoted lines to
>    find the guts of the mail.

ok.

>
> 2) Send patches inline. It's a pain to review and reply and I can't
>    use my normal tooling.

I can not, as gmail does not allow that.


>>
>> Attached patch should address them.
>
>> -       struct resource r = {
>> -               .flags = 0
>> -       };
>> +       struct resource r;
>>
>> +       memset(&r, 0, sizeof(r));
>
> What's the point of this change? Both initialize r to 0. memset()
> generates better code, but that's irrelevant for the problem at hand.

late there is

info->res[info->res_num] = r;

don't want the random pointer in r get copied.

>
>> Please fix it before it get into linus tree.
>
> You can be sure that I'm going to fix the whole mess there proper and
> not by applying a cobbled together bandaid.

Good.

Yinghai
