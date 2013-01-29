Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3A2GWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:22:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab3A2GWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:22:07 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.LFD.2.02.1301282320430.6300@xanadu.home>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <alpine.LFD.2.02.1301282320430.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2013 22:18:04 -0800
To: Nicolas Pitre <nico@fluxnic.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Kyungsik Lee <kyungsik.lee@lge.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>
Message-ID: <bce35b9a-0b62-4655-ad5e-972e2bd51a95@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uhm... you're saying we have to be at one extreme or the other?

We probably could drop the legacy lzma format, but someone might rely on it.

Nicolas Pitre <nico@fluxnic.net> wrote:

>On Mon, 28 Jan 2013, Andrew Morton wrote:
>
>> On Sat, 26 Jan 2013 14:50:43 +0900
>> Kyungsik Lee <kyungsik.lee@lge.com> wrote:
>> 
>> > This patchset is for supporting LZ4 compressed kernel and initial
>ramdisk on
>> > the x86 and ARM architectures.
>> > 
>> > According to http://code.google.com/p/lz4/, LZ4 is a very fast
>lossless
>> > compression algorithm and also features an extremely fast decoder.
>> > 
>> > Kernel Decompression APIs are based on implementation by Yann
>Collet
>> > (http://code.google.com/p/lz4/source/checkout).
>> > De/compression Tools are also provided from the site above.
>> > 
>> > The initial test result on ARM(v7) based board shows that the size
>of kernel
>> > with LZ4 compressed is 8% bigger than LZO compressed  but the
>decompressing
>> > speed is faster(especially under the enabled unaligned memory
>access).
>> > 
>> > Test: 3.4 based kernel built with many modules
>> > Uncompressed kernel size: 13MB
>> > lzo: 6.3MB, 301ms
>> > lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
>> > 
>> > It seems that it___s worth trying LZ4 compressed kernel image or
>ramdisk 
>> > for making the kernel boot more faster.
>> >
>> > ...
>> >
>> >  20 files changed, 663 insertions(+), 3 deletions(-)
>> >
>> > ...
>> >
>> 
>> What's this "with enabled unaligned memory access" thing?  You mean
>"if
>> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
>> that's only x86, which isn't really in the target market for this
>> patch, yes?
>
>I'm guessing this is referring to commit 5010192d5a.
>
>> It's a lot of code for a 50ms boot-time improvement.  Does anyone
>have
>> any opinions on whether or not the benefits are worth the cost?
>
>Well, we used to have only one compressed format.  Now we have nearly 
>half a dozen, with the same worthiness issue between themselves.  
>Either we keep it very simple, or we make it very flexible.  The former
>
>would argue in favor of removing some of the existing formats, the
>later 
>would let this new format in.
>
>
>Nicolas

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
