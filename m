Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaKEREv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:04:51 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:38353 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaKEREG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 5 Nov 2014 12:04:06 -0500
Message-Id: <545A588202000078000C1042@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 05 Nov 2014 17:04:02 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <mingo@kernel.org>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/boot] x86-64: Use RIP-relative addressing for
 most per-CPU accesses
References: <5458A1780200007800044A9D@mail.emea.novell.com>
 <tip-97b67ae559947f1e208439a1bf6a734da3087006@git.kernel.org>
 <545932C3.3080907@zytor.com>
In-Reply-To: <545932C3.3080907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 11/04/14 9:11 PM >>>
>On 11/04/2014 11:45 AM, tip-bot for Jan Beulich wrote:
>> x86-64: Use RIP-relative addressing for most per-CPU accesses
>> 
>> Observing that per-CPU data (in the SMP case) is reachable by
>> exploiting 64-bit address wraparound (building on the default kernel
>> load address being at 16Mb), the one byte shorter RIP-relative
>> addressing form can be used for most per-CPU accesses. The one
>> exception are the "stable" reads, where the use of the "P" operand
>> modifier prevents the compiler from using RIP-relative addressing, but
>> is unavoidable due to the use of the "p" constraint (side note: with
>> gcc 4.9.x the intended effect of this isn't being achieved anymore,
>> see gcc bug 63637).
>> 
>> With the dependency on the minimum kernel load address, arbitrarily
>> low values for CONFIG_PHYSICAL_START are now no longer possible. A
>> link time assertion is being added, directing to the need to increase
>> that value when it triggers.
>> 
>
>This description makes very little sense.  What matters here is the
>virtual address, which is always >= -2 GB.

But code at or very close to -2Gb won't be able to reach addresses far
enough from address zero; it indeed matters that the lowest code address
is far enough away from -2Gb.

Jan

