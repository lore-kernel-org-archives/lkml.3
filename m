Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaE1Vpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:45:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42214 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaE1Vpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:45:30 -0400
Message-ID: <538658EE.8030809@zytor.com>
Date: Wed, 28 May 2014 14:45:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Marian Marinov <mm@1h.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Subject: Re: Pondering per-process vsyscall disablement
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com> <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
In-Reply-To: <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 09:40 AM, Andy Lutomirski wrote:
> 
> I don't think this should be something configured by the
> administrator, unless the administrator is the builder of a kiosky
> thing like Chromium OS.  In that case, the administrator can use
> vsyscall=none.
> 
> I think this should be handled by either libc or the toolchain, hence
> the suggestions of a syscall or an ELF header.
> 

We could mimic the NX stack stuff, but it would have a lot of false
negatives, simply because very few things would actually poke at the
vsyscall page.

The NX stuff uses a dummy program header in the ELF image.

On the other hand, you could make the argument that anything compiled
with a new toolchain simply should not use the vsyscall page, and just
unconditionally set the opt-out bit (header) in question.

It might be better to have some kind of flags field (which a number of
architectures use) than keep using dummy program headers, though.

	-hpa

