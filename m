Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab3EGSuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:50:17 -0400
Received: from smtprelay0132.b.hostedemail.com ([64.98.42.132]:45619 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756226Ab3EGSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:50:14 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2692:2859:2896:2910:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3421:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4361:4605:5007:6117:6119:6261:7875:7903:9025:9036:9108:10004:10400:10450:10455:10848:11658:11914:12043:12517:12519:12555:12663:12740:12926:13091:13161:13229:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netc
X-HE-Tag: cork03_59076525dc757
X-Filterd-Recvd-Size: 4822
Date: Tue, 7 May 2013 18:50:11 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bhelgaas@google.com
Cc: hancockrwd@gmail.com, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, rjw@sisk.pl, psusi@ubuntu.com
Message-ID: <923587421.73140.1367952611687.JavaMail.mail@webmail05>
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
 <384171828.66802.1367942365492.JavaMail.mail@webmail05><CAErSpo75ittZE8pS0e6UGvVY3KXe5+_O=4AMU3ToWVyK9wwZ8g@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.166.176.131]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May 7, 2013 10:27:30 PM, Bjorn Helgaas wrote:
On Tue, May 7, 2013 at 8:59 AM, Artem S. Tashkinov  wrote:
>> May 7, 2013 09:25:40 PM,        Bjorn Helgaas  wrote:
>>> [+cc Phillip]
>>>
>>>> I would suspect that Windows' complaint about the BIOS mucking up the MTRRs
>>>> is likely the best hint. Likely Windows is detecting the problem and fixing
>>>> it up on resume, thus it only complains about "reduced resume performance".
>>>> If the MTRRs are messed up, then quite likely parts of RAM have become
>>>> uncacheable, causing performance to get randomly slaughtered in various
>>>> ways.
>>>>
>>>> From looking at the code it's not clear if we are checking/restoring the
>>>> MTRR contents after resume. If not, maybe we should be.
>>>
>>>I agree; the MTRR warning is a good hint.  Artem?
>>>
>>>Phillip, I cc'd you because you have similar hardware and your
>>>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1131468 report is
>>>slightly similar.  Have you seen anything like this "reduced
>>>performance after resume" issue?  If so, can you collect /proc/mtrr
>>>contents before and after suspending?
>>>
>>
>> Like Robert Hancock correctly noted the Linux kernel lacks the code to check
>> for MTTR changes after resume - I'm not a kernel hacker to write such a code ;-)
>>
>> Likewise there's no code to see if RAM pages have become uncacheable - i.e
>> I've no idea how to check it either.
>>
>> According to /proc/mttr nothing changes on resume - only Windows detects
>> the discrepancy between MTTR regions on resume. dmesg contains no warnings
>> or errors (aside from usual ACPI SATA warnings - but they happen right on
>> boot - so I highly doubt the ACPI or SATA layers can be the culprit, since USB
>> exhibits a similar performance degradation).
>>
>> In short, there's little to nothing that I can check.
>
>I'm not trying to be ungrateful, but maybe you could actually collect
>the info we've asked for and attach it to the bugzilla.  It's hard for
>me to get excited about digging into this when all I see is "nothing
>changes in MTRR" and "it's probably not X."  I really need some
>concrete data to help rule things out and suggest other things to
>investigate.
>
>Maybe we won't be able to make progress on this until other people
>start hitting similar issues and we can find patterns.

The pattern is very easy to spot - Linus once told that desktop PCs are
not meant to work properly with suspend. That's kinda strange for me
as I have yet to encounter a PC where Windows fails to work properly
after resume - maybe I'm lucky - who knows.

Taking into consideration that only few people use Linux, most Linux
users avoid UEFI, very few of them actually use suspend/resume then
it gets very easy to understand why such bug reports are vanishingly
rare.

Asus themselves could have easily debugged this issue if they were
slightly interested in fixing it, yet their policy is that they only support
Windows, and Linux is not their concern.

Best regards
