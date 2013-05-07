Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab3EGP73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:59:29 -0400
Received: from smtprelay0127.b.hostedemail.com ([64.98.42.127]:54242 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757032Ab3EGP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:59:28 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3421:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4361:5007:6117:6261:7875:7903:9025:9108:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12663:12740:13069:13091:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn
X-HE-Tag: spy46_35324c2dd075e
X-Filterd-Recvd-Size: 3644
Date: Tue, 7 May 2013 15:59:25 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bhelgaas@google.com
Cc: hancockrwd@gmail.com, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, rjw@sisk.pl, psusi@ubuntu.com
Message-ID: <384171828.66802.1367942365492.JavaMail.mail@webmail05>
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
 <518097B8.4020402@gmail.com><CAErSpo7KWPRVEnw+n068pUZz+=WSTwno6m6t7N6dunuhnFC8EA@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.166.176.131]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May 7, 2013 09:25:40 PM, 	Bjorn Helgaas  wrote:
> [+cc Phillip]
>
>> I would suspect that Windows' complaint about the BIOS mucking up the MTRRs
>> is likely the best hint. Likely Windows is detecting the problem and fixing
>> it up on resume, thus it only complains about "reduced resume performance".
>> If the MTRRs are messed up, then quite likely parts of RAM have become
>> uncacheable, causing performance to get randomly slaughtered in various
>> ways.
>>
>> From looking at the code it's not clear if we are checking/restoring the
>> MTRR contents after resume. If not, maybe we should be.
>
>I agree; the MTRR warning is a good hint.  Artem?
>
>Phillip, I cc'd you because you have similar hardware and your
>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1131468 report is
>slightly similar.  Have you seen anything like this "reduced
>performance after resume" issue?  If so, can you collect /proc/mtrr
>contents before and after suspending?
>

Like Robert Hancock correctly noted the Linux kernel lacks the code to check
for MTTR changes after resume - I'm not a kernel hacker to write such a code ;-)

Likewise there's no code to see if RAM pages have become uncacheable - i.e
I've no idea how to check it either.

According to /proc/mttr nothing changes on resume - only Windows detects
the discrepancy between MTTR regions on resume. dmesg contains no warnings
or errors (aside from usual ACPI SATA warnings - but they happen right on
boot - so I highly doubt the ACPI or SATA layers can be the culprit, since USB
exhibits a similar performance degradation).

In short, there's little to nothing that I can check.

That bug report has nothing to do with my problem - my PC suspends and
resumes more or less correctly - everything works (albeit some parts don't
work as they should). That person also has a very outdated BIOS -  1904 from
08/15/2011. I wouldn't be surprised if BIOS update solved his problem.

Best regards,

Artem
