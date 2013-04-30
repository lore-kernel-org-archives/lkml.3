Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3D3Er3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:47:29 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38798 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3D3Er0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <771333906.75854.1367057440028.JavaMail.mail@webmail08>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08> <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13> <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
 <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com> <771333906.75854.1367057440028.JavaMail.mail@webmail08>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Apr 2013 22:47:05 -0600
Message-ID: <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 4:10 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>>
>>Did this problem ever get resolved?
>>
>
> Hello,
>
> Unfortunately, no. Out of curiosity I've tried booting kernel
> 3.9-rc8 in EUFI mode but it exhibits the same problem.
>
> Right after the boot:
>
> [root@localhost ~]# dd if=/dev/zero of=test bs=64M count=3
> 3+0 records in
> 3+0 records out
> 201326592 bytes (201 MB) copied, 1.08544 s, 185 MB/s
>
> After suspend/resume:
>
> # dd if=/dev/zero of=test bs=64M count=3
> 3+0 records in
> 3+0 records out
> 201326592 bytes (201 MB) copied, 66.5392 s, 3.0 MB/s
>
> That's for my primary SATA-3 HDD.
>
> Forgive me my impudence but I believe debugging the USB stack is
> tangential to this problem. Something far deeper than USB support
> breaks, but so far no one has come even with the slightest clue of
> what that might be.

I tend to agree that it sounds like something deeper than USB is
broken.  I admit I'm just grasping at straws because I don't have any
good ideas yet.

Here are three easy things you can try:

1) Collect "lspci -vvv -xxxx" output before and after the
suspend/resume to investigate the XHCI Unsupported Request errors.

2) Collect the contents of /proc/mtrr before and after the suspend/resume.

3) After the suspend/resume, try the "setpci" to set the MSI address
back to the original value to see if it makes a difference (see my Feb
12 message).

Bjorn
