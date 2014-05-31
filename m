Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbaEaBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:25:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49902 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608AbaEaBZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:25:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140531011450.GJ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-12-git-send-email-arnd@arndb.de> <20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 30 May 2014 18:22:55 -0700
To: Dave Chinner <david@fromorbit.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Message-ID: <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, not a strawman.  Replace with Jan 26, 2038 and you have the same situation.

On May 30, 2014 6:14:50 PM PDT, Dave Chinner <david@fromorbit.com> wrote:
>On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
>> On 05/30/2014 05:37 PM, Dave Chinner wrote:
>> > 
>> > IOWs, the filesystem has to be able to reject any attempt to set a
>> > timestamp that is can't represent on disk otherwise Bad Stuff will
>> > happen,
>> 
>> Actually it is questionable if it is worse to reject a timestamp or
>just
>> let it wrap.  Rejecting a valid timestamp is a bit like "You don't
>> exist, go away."
>
>I think having the new systems calls being able to
>return EINVAL if the value cannot be stored permanently on disk
>correctly is the right thing to do. Having it silently mangled
>by the filesystem and returning "everything is just fine, trust me"
>is close to the worst solution I can think of. That's exactly what
>leads to overflow bugs occurring....
>
>> > and filesystems have to be able to specify in their on
>> > disk format what timestamp encoding is being used. The solution
>will
>> > be different for every filesystem that needs to support time beyond
>> > 2038.
>> 
>> Actually the cutoff can be really different for each filesystem, not
>> necessarily 2038.  However, I maintain the above still holds.
>
>Sure, but all filesystems are supposed to handle at least the
>current unix epoch.
>
>> Consider a filesystem that kept timestamps in YYMMDDHHMMSS format. 
>What
>> would you have expected such a filesystem to do on Jan 1, 2000?
>
>Strawman.
>
>We don't need to cater for fundamentally broken designs that can't
>even handle the current unix epoch correctly. If such filesystems
>exist, then they can simple say "original unix epoch support only"
>and do whatever crap they are doing right now.
>
>Cheers,
>
>Dave.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
