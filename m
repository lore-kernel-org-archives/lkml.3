Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaKCT1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:27:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35706 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:26:59 -0500
Message-ID: <5457D6FF.5060800@amacapital.net>
Date: Mon, 03 Nov 2014 11:26:55 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Josh Triplett <josh@joshtriplett.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH v4 10/10] x86: Support compiling out userspace IO (iopl
 and ioperm)
References: <cover.1414870871.git.josh@joshtriplett.org>	<ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>	<20141103121049.2f0c81a9@alan.etchedpixels.co.uk>	<20141103141357.GC21818@thin> <20141103152748.327032f8@alan.etchedpixels.co.uk>
In-Reply-To: <20141103152748.327032f8@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 07:27 AM, One Thousand Gnomes wrote:
>>> This isn't unreasonable but there are drivers with userspace helpers that
>>> use iopl/ioperm type functionality where you should be doing a SELECT of
>>> X86_IOPORT. The one that comes to mind is the uvesa driver. From a quick
>>> scan it may these days be the only mainstream one that needs the select
>>> adding.
>>
>> Should kernel drivers really express dependencies that only their
>> (current instances of) corresponding userspace components need?
>> Something seems wrong about that.
> 
> uvesafb will always need X86_IOPORT. It's kind of implicit in the design.
> I'm not suggesting that fbdev should select X86_IOPORT but in the uvesafb
> case at least it's completely useless to have one and not the other.

Are there any users of uvesafb at all?  Last time I changed that driver,
I tried to test it, and I was unable to find a copy of the userspace helper.

--Andy

> 
>> IO_BITMAP_LONGS already gets defined to (0/sizeof(long)).  And as far as
>> I can tell, that would only work for init_tss_io, not anything else.
>> Even then, that would only work with a zero-size array left around in
>> tss_struct, which doesn't seem appropriate.  The remaining ifdefs wrap
>> code that GCC could not constant-fold away, and making that code
>> constant-foldable seems significantly more invasive than the ifdefs.
> 
> OK
> 

