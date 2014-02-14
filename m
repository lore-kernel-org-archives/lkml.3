Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaBNSkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:40:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaBNSj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:39:59 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1402141924170.21991@ionos.tec.linutronix.de>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5D91.6060005@zytor.com> <alpine.DEB.2.02.1402141917320.21991@ionos.tec.linutronix.de> <52FE5ED4.4040508@zytor.com> <alpine.DEB.2.02.1402141924170.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 14 Feb 2014 10:39:40 -0800
To: Thomas Gleixner <tglx@linutronix.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Message-ID: <a1204336-ad8d-4f2f-8078-24f043f123e6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could also just add an ACPI table... same concept.  Still need to find it.

On February 14, 2014 10:38:24 AM PST, Thomas Gleixner <tglx@linutronix.de> wrote:
>On Fri, 14 Feb 2014, H. Peter Anvin wrote:
>> On 02/14/2014 10:21 AM, Thomas Gleixner wrote:
>> > I wish we could just use devicetree for such cases and fix the crud
>> > ourself.
>> > 
>> 
>> We'd have to identify the platform, which is the main problem.  Right
>> now we support quirking for DMI or PCI, but I don't think we do for
>MPTABLE.
>
>My point is that device tree support for some basic stuff like
>hpet/ioapic and such would allow people like Conrad to avoid the
>stupid hackery of quirks.
>
>Building your own DT requires to read a datasheet as does hacking a
>quirk, but its definitely simpler. And we can collect the DTs for
>known boards either in the kernel or in some external repository.
>
>People who are dealing with embedded stuff are not those who are
>frightened by datasheets and building a custom kernel with some extra
>blob.
>
>I bet Conrad is also stuck with PIC on the E6xx CPU and that's a major
>PITA. I have such a board as well and it simply sucks.
>
>Now you can't hack an ioapic quirk because that's way to complex, but
>we have proven with the ce4100 that it is reasonably simple to get
>that stuff working nicely when you can read a datasheet. If we could
>generalize that for a few crucial devices that would help a lot.
>
>When I asked the board vendor why there are no acpi tables in the
>device, I got the answer, that this is an embedded board and the
>"BIOS" built with BLDK does not support that. We all know that's not
>true, but how does that help?
>
>The people who brought up the initial target OS (WinCE) on that board
>worked around the lack of ACPI by hacking HPET support into the CE
>preloader and switched all device drivers to use MSI because CE failed
>to handle the PIC properly. That avoided that they needed to hack the
>ioapic into submission as well.
>
>That's the sad reality. And we have to cope with these boards whether
>we like it or not.
>
>Thanks,
>
>	tglx

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
