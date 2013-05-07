Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3EGWDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:03:20 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60347 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3EGWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAMeQTsZEpRE_bv6o9mBpqNrbf36SZVscxy+JS72=BOzA1ey-XQ@mail.gmail.com>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08> <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13> <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
 <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com>
 <771333906.75854.1367057440028.JavaMail.mail@webmail08> <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com>
 <518097B8.4020402@gmail.com> <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
 <384171828.66802.1367942365492.JavaMail.mail@webmail05> <CADLC3L3bdTP8-X3ftMq1qxnL=LVDf7d5gbu2ZMH0pXg2AU8xjw@mail.gmail.com>
 <CAErSpo50iyEbCer+-K8uXUdnsG_EzFe_ZjKnrtfq5x0Zw3Yd6w@mail.gmail.com> <CAMeQTsZEpRE_bv6o9mBpqNrbf36SZVscxy+JS72=BOzA1ey-XQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 7 May 2013 15:02:57 -0700
Message-ID: <CAErSpo75SETEe-OKhY2-NW3csaxt=f09JcheHx95bzkCcGO6yg@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Phillip Susi <psusi@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 2:48 PM, Patrik Jakobsson
<patrik.r.jakobsson@gmail.com> wrote:
> On Tue, May 7, 2013 at 10:20 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> I'm not sure if reading /proc/mtrr actually reads the registers out of
>>> the CPU each time, or whether we just return the cached values we read
>>> out during initial boot-up. If the latter, then this output isn't
>>> really useful as there's no guarantee the values are still intact.
>>
>> Good point.  From what I can tell, on Artem's system with "CPU0:
>> Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz," we would be using
>> generic_mtrr_ops, and generic_get_mtrr() appears to read from the
>> MSRs, so I think it should be useful.
>
> FWIW, that motherboard suffers from a PCI to PCIE bridge problem. It might
> have been fixed by bios upgrades by now but not sure.
>
> It might also suffer (depending on the revision) from the Sandy bridge SATA
> issue. So if affected, SATA controller is a ticking bomb.
>
> I have a P8H67-V motherboard but I haven't seen any suspend related issues.
>
> If this is totally unrelated I'm sorry for wasting your time. Just thought it
> might be good to know.

Thanks for chiming in.  I'm not familiar with either of the issues you
mentioned.  Do you have any references where I could read up on them?

Artem's system has a PCIe-to-PCI bridge (not a PCI-to-PCIe bridge) at
05:00.0, but it leads to [bus 06] and there's nothing on bus 06, so I
don't think that's the problem.

And the issue affects both USB and a hard drive, so I suspect it's
more than just SATA.  Artem, did you identify the PCI devices leading
to your USB and hard drive?  I can't remember if I've actually seen
that.

Bjorn
