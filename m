Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3EGQ1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:27:31 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34776 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3EGQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <384171828.66802.1367942365492.JavaMail.mail@webmail05>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08> <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13> <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
 <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com>
 <771333906.75854.1367057440028.JavaMail.mail@webmail08> <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com>
 <518097B8.4020402@gmail.com> <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
 <384171828.66802.1367942365492.JavaMail.mail@webmail05>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 7 May 2013 09:27:09 -0700
Message-ID: <CAErSpo75ittZE8pS0e6UGvVY3KXe5+_O=4AMU3ToWVyK9wwZ8g@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, psusi@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 8:59 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> May 7, 2013 09:25:40 PM,        Bjorn Helgaas  wrote:
>> [+cc Phillip]
>>
>>> I would suspect that Windows' complaint about the BIOS mucking up the MTRRs
>>> is likely the best hint. Likely Windows is detecting the problem and fixing
>>> it up on resume, thus it only complains about "reduced resume performance".
>>> If the MTRRs are messed up, then quite likely parts of RAM have become
>>> uncacheable, causing performance to get randomly slaughtered in various
>>> ways.
>>>
>>> From looking at the code it's not clear if we are checking/restoring the
>>> MTRR contents after resume. If not, maybe we should be.
>>
>>I agree; the MTRR warning is a good hint.  Artem?
>>
>>Phillip, I cc'd you because you have similar hardware and your
>>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1131468 report is
>>slightly similar.  Have you seen anything like this "reduced
>>performance after resume" issue?  If so, can you collect /proc/mtrr
>>contents before and after suspending?
>>
>
> Like Robert Hancock correctly noted the Linux kernel lacks the code to check
> for MTTR changes after resume - I'm not a kernel hacker to write such a code ;-)
>
> Likewise there's no code to see if RAM pages have become uncacheable - i.e
> I've no idea how to check it either.
>
> According to /proc/mttr nothing changes on resume - only Windows detects
> the discrepancy between MTTR regions on resume. dmesg contains no warnings
> or errors (aside from usual ACPI SATA warnings - but they happen right on
> boot - so I highly doubt the ACPI or SATA layers can be the culprit, since USB
> exhibits a similar performance degradation).
>
> In short, there's little to nothing that I can check.

I'm not trying to be ungrateful, but maybe you could actually collect
the info we've asked for and attach it to the bugzilla.  It's hard for
me to get excited about digging into this when all I see is "nothing
changes in MTRR" and "it's probably not X."  I really need some
concrete data to help rule things out and suggest other things to
investigate.

Maybe we won't be able to make progress on this until other people
start hitting similar issues and we can find patterns.

Bjorn
