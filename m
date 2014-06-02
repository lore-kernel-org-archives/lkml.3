Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaFBO4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:56:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51693 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbaFBO4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:56:02 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <20140602115737.GB14276@thunk.org>
Date: Mon, 2 Jun 2014 07:52:47 -0700
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "joseph@codesourcery.com" <joseph@codesourcery.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "lftan@altera.com" <lftan@altera.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A37F9FD2-DD07-4EB0-A94B-C22141715911@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <8618458.1EVJCoVbkH@wuerfel> <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr> <4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jun 2, 2014, at 4:57, "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
>> On Mon, Jun 02, 2014 at 12:56:42PM +0200, Arnd Bergmann wrote:
>> 
>> I think you misunderstood what I suggested: the intent is to avoid
>> seeing things break in 2038 by making them break much earlier. We have
>> a solution for ext2 file systems, it's called ext4, and we just need
>> to ensure that everybody knows they have to migrate eventually.
>> 
>> At some point before the mid 2030ies, you should no longer be able to
>> build a kernel that has support for ext2 or any other module that will
>> run into bugs later....
> 
> Even for ext4, it's not quite so simple as that.  You only have
> support for times post 2038 if you are using an inode size > 128
> bytes.  There are a very, very large number of machines which even
> today, are using 128 byte inodes with ext4 for performance reasons.
> 
> The vast majority of those machines which I know of can probably move
> to 256 byte inodes relatively easily, since hard drive replacement
> cycles are order 5-6 years tops, so I'm not that concerned, but it
> just goes to show this is a very complicated problem.
> 
> And even if we're talking about flash and embedded devices, the good
> news is if you assume that 10 years is enough time for people to
> update their embedded OS builds, and that the vast majority of
> deployed devices will probably only be in service for 10-15 years, we
> do have enough time to make file system format changes, although
> admittedly we can't afford to dilly-dally.

I have a number of file systems older than any device they are sitting on.  RAID allows individual disks to be swapped out, and when all disks have been swapped out, extend the file system online.  The system doesn't even have to be taken offline in the process if it is possible to physically get to the drives with the system powered (e.g. hot plug bays), which is really damned nice.