Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3KMECa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 23:02:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43666 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab3KMECY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 23:02:24 -0500
Message-ID: <5282F9C1.3020007@zytor.com>
Date: Tue, 12 Nov 2013 20:02:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
References: <cover.1383868558.git.price@mit.edu> <20131112042444.GC30281@thunk.org> <20131112224009.GX8043@ringworld.MIT.EDU> <20131113033205.GA9214@thunk.org>
In-Reply-To: <20131113033205.GA9214@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 07:32 PM, Theodore Ts'o wrote:
> On Tue, Nov 12, 2013 at 05:40:09PM -0500, Greg Price wrote:
>>
>> Beyond these easy cleanups, I have a couple of patches queued up (just
>> written yesterday, not quite finished) to make /dev/urandom block at
>> boot until it has enough entropy, as the "Mining your P's and Q's"
>> paper recommended and people have occasionally discussed since then.
>> Those patches were definitely for after 3.13 anyway, and I'll send
>> them when they're ready.  I see some notifications and warnings in
>> this direction in the random.git tree, which is great.
> 
> One of the things I've been thinking about with respect to making
> /dev/urandom block is being able to configure (via a module parameter
> which could be specified on the boot command line) which allows us to
> set a limit for how long /dev/urandom will block after which we log a
> high priority message that there was an attempt to read from
> /dev/urandom which couldn't be satisified, and then allowing the
> /dev/urandom read to succed.
> 
> The basic idea is that we don't want to break systems, but we do want
> to gently coerce people to do the right thing.  Otherwise, I'm worried
> that distros, or embedded/mobile/consume electronics engineers would
> just patch out the check.  If we make the default be something like
> "block for 5 minutes", and then log a message, we won't completely
> break a user who is trying to login to a VM, but it will be obvious,
> both from the delay and from the kern.crit log message, that there is
> a potential problem here that a system administrator needs to worry
> about.
> 

One thing, too, if we are talking about anything other than
boot-time-only blocking: going from a nonblocking to a blocking
condition means being able to accept a short read, and right now *many*
users of /dev/urandom are not ready to accept a short read.

	-hpa


