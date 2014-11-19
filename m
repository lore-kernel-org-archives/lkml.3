Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaKSQzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:55:36 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55388 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaKSQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:55:35 -0500
Date: Wed, 19 Nov 2014 16:55:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
Message-ID: <20141119165517.GL4042@n2100.arm.linux.org.uk>
References: <20141118173413.GB4042@n2100.arm.linux.org.uk>
 <546B8C64.3010904@samsung.com>
 <2041617.Kxhx5O4MMr@wuerfel>
 <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
 <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
 <20141119160747.GH4042@n2100.arm.linux.org.uk>
 <CAKv+Gu-kvmkhrptmaN0miM3c0K3ZOh4maTFXL=NpYTMi9Q83kA@mail.gmail.com>
 <CALYGNiN5XC_4MhRbxZmFW5Jmc1N1H32tSZr3kKf_UBFriG71nA@mail.gmail.com>
 <CAKv+Gu8o_-Q5PeFqdQXW=mcHNYxFcLLnvxjq94y-iG8+JUp=9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8o_-Q5PeFqdQXW=mcHNYxFcLLnvxjq94y-iG8+JUp=9w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:38:57PM +0100, Ard Biesheuvel wrote:
> Numbers are disambiguated by the f and b suffixes, so they can be
> reused in the same .s file. So as long as you use a strictly numerical
> prefix, you can deal correctly with the case where, for instance,
> do_div() is called twice in the same compilation unit, and still not
> clash with other inline asm

What's not particularly nice though is to hide these in a macro,
which itself may be part of a larger macro or code fragment also
using small numbers.

We probably ought to be a bit more inteligent about how we choose
these numbers inside macros, rather than just randomly picking some
and hoping that they don't clash.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
