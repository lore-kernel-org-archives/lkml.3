Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3A3Dj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:39:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44767 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3A3Djx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:39:53 -0500
Message-ID: <51089523.3080804@zytor.com>
Date: Tue, 29 Jan 2013 19:36:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
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
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <20130129101549.GP23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130129101549.GP23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 02:15 AM, Russell King - ARM Linux wrote:
> On Mon, Jan 28, 2013 at 02:25:10PM -0800, Andrew Morton wrote:
>> What's this "with enabled unaligned memory access" thing?  You mean "if
>> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
>> that's only x86, which isn't really in the target market for this
>> patch, yes?
>>
>> It's a lot of code for a 50ms boot-time improvement.  Does anyone have
>> any opinions on whether or not the benefits are worth the cost?
>
> Well... when I saw this my immediate reaction was "oh no, yet another
> decompressor for the kernel".  We have five of these things already.
> Do we really need a sixth?
>
> My feeling is that we should have:
> - one decompressor which is the fastest
> - one decompressor for the highest compression ratio
> - one popular decompressor (eg conventional gzip)
>
> And if we have a replacement one for one of these, then it should do
> exactly that: replace it.  I realise that various architectures will
> behave differently, so we should really be looking at numbers across
> several arches.
>
> Otherwise, where do we stop adding new ones?  After we have 6 of these
> (which is after this one).  After 12?  After the 20th?
>

The only concern I have with that is if someone paints themselves into a 
corner and absolutely wants, say, LZO.

Otherwise, per your list it pretty much sounds like we should have lz4, 
gzip, and xz.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

