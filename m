Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaKSQ7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:59:23 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52922 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaKSQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:59:22 -0500
Date: Wed, 19 Nov 2014 11:59:18 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
In-Reply-To: <20141119165517.GL4042@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1411191158010.11690@knanqh.ubzr>
References: <20141118173413.GB4042@n2100.arm.linux.org.uk> <546B8C64.3010904@samsung.com> <2041617.Kxhx5O4MMr@wuerfel> <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com> <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com> <20141119160747.GH4042@n2100.arm.linux.org.uk> <CAKv+Gu-kvmkhrptmaN0miM3c0K3ZOh4maTFXL=NpYTMi9Q83kA@mail.gmail.com> <CALYGNiN5XC_4MhRbxZmFW5Jmc1N1H32tSZr3kKf_UBFriG71nA@mail.gmail.com>
 <CAKv+Gu8o_-Q5PeFqdQXW=mcHNYxFcLLnvxjq94y-iG8+JUp=9w@mail.gmail.com> <20141119165517.GL4042@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Russell King - ARM Linux wrote:

> On Wed, Nov 19, 2014 at 05:38:57PM +0100, Ard Biesheuvel wrote:
> > Numbers are disambiguated by the f and b suffixes, so they can be
> > reused in the same .s file. So as long as you use a strictly numerical
> > prefix, you can deal correctly with the case where, for instance,
> > do_div() is called twice in the same compilation unit, and still not
> > clash with other inline asm
> 
> What's not particularly nice though is to hide these in a macro,
> which itself may be part of a larger macro or code fragment also
> using small numbers.
> 
> We probably ought to be a bit more inteligent about how we choose
> these numbers inside macros, rather than just randomly picking some
> and hoping that they don't clash.

Maybe in this case, the macro content is so simple that labels are not 
warranted?  Getting away without them certainly solves the issue.


Nicolas
