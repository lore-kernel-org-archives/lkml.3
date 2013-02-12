Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167Ab3BLPCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:02:51 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:56239 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760056Ab3BLPCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:02:50 -0500
Message-ID: <511A5995.5000607@parrot.com>
Date: Tue, 12 Feb 2013 16:02:45 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
References: <5112DC7E.4020108@dawncrow.de> <20130206225150.GL17833@n2100.arm.linux.org.uk> <5112E0C3.1080706@dawncrow.de> <20130208154809.GF3495@mudshark.cambridge.arm.com> <511A4B93.1000700@dawncrow.de> <20130212140950.GC4123@mudshark.cambridge.arm.com>
In-Reply-To: <20130212140950.GC4123@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon a écrit :
> Hi Andre,
> 
> On Tue, Feb 12, 2013 at 02:02:59PM +0000, André Hentschel wrote:
>> Am 08.02.2013 16:48, schrieb Will Deacon:
>>> On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
>>>> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?
>>> How about something like the (completely untested) diff below?
>>>
>>> Andre: if this works for you, I'm happy to write a commit message etc.
>> Thx for your effort, but it doesn't work, at least not with my 3.4.6 suse kernel.
>> Be free to have another try, i'll be happy to test it.
> 
> Well, cheers for testing. Can you be more specific about what goes wrong
> please? What do you see in TPIDRURW?
> 
The tls value is never saved to : thread->tp_value[1].

Also I don't know if you can avoid the extra ldr in the software case.

Matthieu
