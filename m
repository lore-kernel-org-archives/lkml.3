Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaEaJLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 05:11:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaEaJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 05:11:44 -0400
Message-ID: <53899C95.80806@zytor.com>
Date: Sat, 31 May 2014 02:10:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [RFC 13/32] ext3: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1401480116-1973111-14-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> ext3fs uses unsigned 32-bit seconds for inode timestamps, which will work
> for the next 92 years, but the VFS uses struct timespec for timestamps,
> which is only good until 2038 on 32-bit CPUs.
> 
> This gets us one small step closer to lifting the VFS limit by using
> struct inode_time in ext3. The on-disk format limit is lifted in ext4,
> which will work until 2514.
> 

This may be what the spec says, but when I experimented with this just
now it does seem that both ext2 and ext3 actually interpret timestamps
as *signed* 32-bit seconds.

	-hpa

