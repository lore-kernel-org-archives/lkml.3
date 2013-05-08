Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3EHIbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:31:36 -0400
Received: from smtprelay0012.b.hostedemail.com ([64.98.42.12]:57306 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751439Ab3EHIbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:31:33 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2561:2564:2682:2685:2859:2892:2896:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3421:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4361:5007:6117:6261:7903:9025:9036:9108:10004:10400:10848:11658:11854:11914:12043:12517:12519:12555:12660:12663:12698:12737:12740:13091:13161:13229,0,RBL:none,CacheI
X-HE-Tag: dime02_81ba56ccfe453
X-Filterd-Recvd-Size: 4126
Date: Wed, 8 May 2013 08:31:31 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bhelgaas@google.com
Cc: patrik.r.jakobsson@gmail.com, hancockrwd@gmail.com,
        stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl,
        psusi@ubuntu.com
Message-ID: <1286745947.88808.1368001891472.JavaMail.mail@webmail05>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08>
 <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13>
 <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
 <CAErSpo4X+XXKvWDfqh2CKZAtJ9WMQk91OcsWwdxwYv2MfEM_zQ@mail.gmail.com>
 <771333906.75854.1367057440028.JavaMail.mail@webmail08>
 <CAErSpo4B4sRco-nuqgXiYtGQxBcbEB6ArQjHD0A9cj4TRE+qQw@mail.gmail.com>
 <518097B8.4020402@gmail.com>
 <CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
 <384171828.66802.1367942365492.JavaMail.mail@webmail05>
 <CADLC3L3bdTP8-X3ftMq1qxnL=LVDf7d5gbu2ZMH0pXg2AU8xjw@mail.gmail.com>
 <CAErSpo50iyEbCer+-K8uXUdnsG_EzFe_ZjKnrtfq5x0Zw3Yd6w@mail.gmail.com>
 <CAMeQTsZEpRE_bv6o9mBpqNrbf36SZVscxy+JS72=BOzA1ey-XQ@mail.gmail.com><CAErSpo75SETEe-OKhY2-NW3csaxt=f09JcheHx95bzkCcGO6yg@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.255.128.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May 8, 2013 04:03:18 AM, Bjorn Helgaas wrote:
On Tue, May 7, 2013 at 2:48 PM, Patrik Jakobsson
> wrote:
>> On Tue, May 7, 2013 at 10:20 PM, Bjorn Helgaas 
 wrote:
>>>> I'm not sure if reading /proc/mtrr actually reads the registers out of
>>>> the CPU each time, or whether we just return the cached values we read
>>>> out during initial boot-up. If the latter, then this output isn't
>>>> really useful as there's no guarantee the values are still intact.
>>>
>>> Good point.  From what I can tell, on Artem's system with "CPU0:
>>> Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz," we would be using
>>> generic_mtrr_ops, and generic_get_mtrr() appears to read from the
>>> MSRs, so I think it should be useful.
>>
>> FWIW, that motherboard suffers from a PCI to PCIE bridge problem. It might
>> have been fixed by bios upgrades by now but not sure.
>>
>> It might also suffer (depending on the revision) from the Sandy bridge SATA
>> issue. So if affected, SATA controller is a ticking bomb.
>>
>> I have a P8H67-V motherboard but I haven't seen any suspend related issues.
>>
>> If this is totally unrelated I'm sorry for wasting your time. Just thought it
>> might be good to know.
>
>Thanks for chiming in.  I'm not familiar with either of the issues you
>mentioned.  Do you have any references where I could read up on them?
>
>Artem's system has a PCIe-to-PCI bridge (not a PCI-to-PCIe bridge) at
>05:00.0, but it leads to [bus 06] and there's nothing on bus 06, so I
>don't think that's the problem.
>
>And the issue affects both USB and a hard drive, so I suspect it's
>more than just SATA.  Artem, did you identify the PCI devices leading
>to your USB and hard drive?  I can't remember if I've actually seen
>that.

I posted my lspci information here https://bugzilla.kernel.org/show_bug.cgi?id=53551

If that's not enough, please tell how can I collect this information.

The SATA issue is discussed here: https://bugzilla.kernel.org/show_bug.cgi?id=43229

According to Intel and Linux kernel developers it poses no threat.

Best regards,

Artem
