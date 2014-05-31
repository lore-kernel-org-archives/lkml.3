Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaEaO44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:56:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56113 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaEaO4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:56:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <6491264.Vk0CYaEpvf@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-2-git-send-email-arnd@arndb.de> <53899AEA.1010909@zytor.com> <6491264.Vk0CYaEpvf@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 31 May 2014 07:55:33 -0700
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org
Message-ID: <62af18d5-6a59-4f5e-95af-1607d2249f33@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, s64/u32 or s64/s32.

On May 31, 2014 7:53:01 AM PDT, Arnd Bergmann <arnd@arndb.de> wrote:
>On Saturday 31 May 2014 02:03:38 H. Peter Anvin wrote:
>> On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
>> > +#ifdef CONFIG_NEW_INODE_TIME
>> > +/*
>> > + * This is the type we use internally in the kernel to represent
>> > + * absolute times in file system metadata.
>> > + * This structure must not leak out to user space, and new
>interfaces
>> > + * should be using 64-bit types right away.
>> > + */
>> > +
>> > +/*
>> > + * Variant a) using unsigned seconds lets us extend the life span
>> > + * for another 69 years beyond 2038.
>> > + */
>> > +struct inode_time {
>> > +     unsigned long   tv_sec;
>> > +     long            tv_nsec;
>> > +};
>> 
>> This now differs between 32- and 64-bit systems, and on 32-bit
>systems
>> some timestamps well within the range of representation of current
>> systems just became unrepresentable, which is something that I
>thought
>> people were objecting very strongly to.
>
>It really depends on the file system. As you pointed out, I was reading
>the ext2/ext3 and xfs code incorrectly, so my assumption when I wrote
>this
>was that they already used the same type, with a 1970-2106 window,
>rather
>than the regular signed Unix epoch.
>
>> > +#elif 0
>> > +/*
>> > + * This variant can represent the widest range of times, but also
>> > + * bloats 'struct inode' a little more.
>> > + */
>> > +struct inode_time {
>> > +     long long       tv_sec __attribute__((packed));
>> > +     int             tv_nsec;
>> > +};
>> 
>> Seriously, though, can we really impose constraints stricter than
>what
>> the filesystems themselves do?  It seems we ought to be able to
>> represent whatever time the filesystem can represent... (modulo some
>> kind of window control as Y2038 or any other break point approaches.)
>
>Just to make sure, do you say we should be using the 'long long/int'
>struct, or something else?
>
>	Arnd

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
