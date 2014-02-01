Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbaBAQnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:43:46 -0500
Received: from www.sr71.net ([198.145.64.142]:60815 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaBAQnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:43:45 -0500
Message-ID: <52ED244B.4090007@sr71.net>
Date: Sat, 01 Feb 2014 08:43:55 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix the initialization of physnode_map
References: <20140131110517.4b7e86d6@hananiah.suse.cz>	<52EC1235.30909@sr71.net> <20140201131312.5b63fde3@hananiah.suse.cz>
In-Reply-To: <20140201131312.5b63fde3@hananiah.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 04:13 AM, Petr Tesarik wrote:
>> > Just curious, but
>> > what the heck kind of 32-bit NUMA hardware is still in the wild?  Did
>> > someon buy a NUMA-Q on eBay? :)
> In fact, this is a patch that has been floating around in SUSE
> Enterprise kernels for some time. It was originally added to pass
> certification on IBM SurePOS 700 x4900-785.
> 
> When cleaning up our kernel patches, I noticed that the bug is still
> present in the upstream kernel, so I posted this patch. While I don't
> have any evidence that someone actually needs the fix today, it seems
> wrong to leave buggy code in the kernel.
> 
> If you all agree that we rip off DISCONTIGMEM instead, I can post
> patches to do that and be equally happy. ;-)

I have a soft spot in my heart for all that old 32-bit NUMA hardware.
I've been thinking about ripping the support out, but it usually sits
quietly not bothering anybody.

Your patch looks correct to me, and it's easier to tell that it is
correct if you just change the alignment.  The only bummer here is that
it's going to be hard to test for correctness since it sounds like you
don't have the hardware sitting in front of you.  In any case, feel free
to add my:

Acked-by: Dave Hansen <dave@sr71.net>
