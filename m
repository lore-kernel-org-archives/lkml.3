Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3GJUu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:50:59 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45444 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3GJUu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <1373477126220-681610.post@n7.nabble.com>
References: <494703114.34959.1360492995961.JavaMail.mail@webmail19>
 <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com> <1373477126220-681610.post@n7.nabble.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Jul 2013 14:50:35 -0600
Message-ID: <CAErSpo5YK=JKqjJZyd=QgOqqmCwFD5X-2CqvTn2N50_Bc6hBrw@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: hyphop <email2tema@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Phillip Susi <psusi@ubuntu.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, hendrik.haddorp@gmx.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc previous cc list from lkml]

On Wed, Jul 10, 2013 at 11:25 AM, hyphop <email2tema@gmail.com> wrote:
> hello
> i have same problem. low write speed after system sleep
>
> kernel 3.9.9
>
> i can see it HDD SATA & USB disks to
>
> i try to make another test
>
> before sleep i make  file /tmp/test ( /tmp mounted as tmpfs size=8G, i have
> 16G memory in my system )
>
> dd if=/dev/zero bs=1M count=1000 of=/tmp/test
>  ~ 3,2 GB/s
> cryptsetup luksFormat /tmp/test
> cryptsetup luksOpen /tmp/test test
>
> dd if=/dev/zero bs=1M count=1000 of=/dev/mapper/test
>  ~ 465 GB/s good speed
>
> after sleep
>
> dd if=/dev/zero bs=1M count=1000 of=/dev/mapper/test
>  ~ 5MB/s ooops (((( very slow
>
> but if write directly in /tmp i can see
>
> dd if=/dev/zero bs=1M count=1000 of=/tmp/test2
>  ~ 3,2 GB/s
>
> I can see this is not hardware problem (NOT SATA OR USB) i think is kernel
> BUG, i i dont have this problem on previous kernel 3.4

Thanks for this report.  Artem collected some of his info here:
https://bugzilla.kernel.org/show_bug.cgi?id=53551 .  Hendrik Haddorp
also reported seeing this issue there.

Artem reported that Windows complains "The system firmware has changed
the processor's memory type range registers (MTRRs) across a sleep
state transition (S4). This can result in reduced resume performance."
 If you have Windows on your system, does it complain the same way?

Can you collect and attach complete dmesg and "lspci -vvv" logs, from
both working and broken kernels, to the bugzilla?  Collect lspci logs
both before and after the sleep; I think Artem saw some differences
between those, and I'm not sure we completely ruled those out.

If anybody can reproduce this reliably enough to bisect it, that would
be a huge help.

Bjorn
