Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3BZTOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:14:53 -0500
Received: from smtprelay0057.b.hostedemail.com ([64.98.42.57]:53153 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932631Ab3BZTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:14:50 -0500
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::,RULES_HIT:152:355:379:582:599:601:967:973:974:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2525:2553:2560:2563:2682:2685:2692:2693:2731:2859:2892:2896:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3421:3622:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4361:5007:6117:6119:6261:7679:7808:7903:8700:9025:9036:9108:10004:10400:10848:11658:11914:12043:12050:12517:12519:12555:12698:12737:12740:13091:13095,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,omf02|3849570048|6143F38
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 4215
Date: Tue, 26 Feb 2013 19:14:48 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bhelgaas@google.com
Cc: stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl
Message-ID: <569718148.80620.1361906088301.JavaMail.mail@webmail13>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08><CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.151.24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feb 27, 2013 12:47:01 AM, Bjorn Helgaas wrote:
On Mon, Feb 25, 2013 at 11:35 PM, Artem S. Tashkinov wrote:
>> Feb 26, 2013 03:57:52 AM, Bjorn Helgaas wrote:
>>>
>>>Where are we at with this, Artem?  I assume it's still a problem.
>>>
>>
>> Yes, it is, Bjorn.
>>
>> In order to eliminate this problem I switched back to MBR yesterday, because
>> so far I haven't received any instructions or guidance as to how I can debug
>> it further. I'm absolutely sure USB write speed is just another manifestation of
>> it so I decided not to debug USB specifically (it just doesn't make too much
>> sense).
>>
>> What I see is that something terribly wrong is going on but if Linus has no ideas
>> I, as an average Joe, don't have a slightest clue as to what I can do.
>>
>> The bug report with necessary, but seemingly useless information, can be
>> found here: https://bugzilla.kernel.org/show_bug.cgi?id=53551
>>
>> If anyone comes up with new ideas I can quickly try UEFI again now that I
>> have two HDDs at my disposal (the old one is formatted as GPT, the new one is
>> MBR).
>
>The ideas I saw are:
>
>1) Figure out whether it ever worked.  If an older kernel worked
>correctly and a newer one is broken, bisection is at least a
>possibility.  You mentioned that it did work before (Feb 12), but in
>the past you never suspended twice in one boot session, whereas maybe
>you did when seeing the problem?

This is difficult to say since the first kernel I tried to run in EUFI mode was
3.7.x, so I've no idea if any previous ones ever worked.

>
>2) Try the "setpci" to set the MSI address back to the original value
>to see if it makes a difference (see my Feb 12 message).

I will try it soon and report back to you.

>
>3) Collect "lspci -vvv -xxxx" output to investigate the XHCI
>Unsupported Request errors.
>
>4) Use usbmon to collect traces before and after the suspend.

Likewise. Still I don't quite understand why you are persistent in your
desire to investigate USB controllers specifically - my problem affects
all storage devices that I have.

>
>I googled around a bit looking for similar reports.  I found lots of
>suspend issues, mostly with Windows, but no leads yet.  It looks like
>the board has been around for a while, so you would think we'd have
>some other reports of a problem this bad.  But maybe it really is
>related to UEFI and nobody really uses that yet?

99% of people around me don't use UEFI, and the ones who use it do
it because they want to run Hacintosh (it's quite complicated to run
a EUFI OS from a non UEFI BIOS).

That's the main reason you don't see similar reports. EUFI so far hasn't
proven its supremacy and efficiency over BIOS. When 3TB and larger
HDD's become more widespread people will have to use UEFI. They will
simply have no choice (unless of course you have two HDDs, where one
is BIOS formatted to boot your system, and another one is GPT
partitioned in order to support > 2,2TB space).

Best regards,

Artem
