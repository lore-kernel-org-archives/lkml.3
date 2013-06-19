Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935211Ab3FSVnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:43:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41959 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935023Ab3FSVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:43:08 -0400
Message-ID: <51C225D9.8070100@zytor.com>
Date: Wed, 19 Jun 2013 14:42:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on defaults.
References: <20130618041132.GA23492@redhat.com> <20130618084356.GA13123@pd.tnic> <20130618140730.GA1313@redhat.com> <20130618155919.GC13123@pd.tnic>
In-Reply-To: <20130618155919.GC13123@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 08:59 AM, Borislav Petkov wrote:
> On Tue, Jun 18, 2013 at 10:07:30AM -0400, Dave Jones wrote:
>> My intent here was to ignore cases where the reserved bits haven't
>> been set. I occasionally see DR6: 00000000fffe0ff0 for eg.
> 
> That's bit 16 which, according to the docs is read-as-1:
> 
> "All remaining bits in the DR6 register are reserved. Reserved bits
> 31:16 and 11:4 must all be set to 1, while reserved bit 12 must be
> cleared to 0. In 64-bit mode, the upper 32 bits of DR6 are reserved and
> must be written with zeros. Writing a 1 to any of the upper 32 bits
> results in a general-protection exception, #GP(0)."
> 
> This above if from AMD APM and Intel's SDM has a graphic showing the
> exact same thing:
> 
> [31:16] = set to 1; [12] = 0b, [11:4] = 1b
> 
> So if you see bit 16 cleared, then some BIOS or even hardware is doing
> funky things. I wouldn't wonder at all if BIOS dudes used reserved bits
> in registers as scratch space.
> 
>> But maybe you're right, and that is a clue and is worth printing ? I
>> can't personally recall ever diagnosing a bug using those register
>> dumps in the last 15 years.
> 
> Right, I don't know whether it would always help but if you have an
> oops and see, say bit 0 in DR6 set, i.e. a debug exception was caused
> by address breakpoint condition in DR0, then that could be useful info,
> methinks.
> 

There is serious confusion with regards to DR6 about the bits which are
*fixed* (forced to 1) and the ones which are *reserved* (should always
have a fixed value.)

There are some bits in DR6 which are used by hardware probes.

	-hpa


