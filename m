Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3BDDCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:02:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37283 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3BDDC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:02:28 -0500
Date: Mon, 4 Feb 2013 03:02:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130204030221.GY4503@ZenIV.linux.org.uk>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
 <20130127195714.GA11224@samfundet.no>
 <20130127203009.GG4503@ZenIV.linux.org.uk>
 <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
 <20130204013111.GX4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204013111.GX4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:31:11AM +0000, Al Viro wrote:

> Unless I'm misreading ocavr32.pdf, that should be (R12, R10:R11, R9, R8) and
> (R12, R10:R11, R9:R8, stack) resp., so fadvise64 doesn't need a wrapper, but
> fadvise64_64 does.  And something like (s32, s32, s64, s64) would turn into
> (R12, R11, R9:R8, stack, stack); AFAICS, we don't have anything that ugly...

Oh, yes, we do - fallocate(2).  int fd, int mode, loff_t offset, loff_t len.
On something like mips or sparc32 it packs nicely; on avr32 it doesn't.
Could you confirm that I haven't misparsed the ABI?

> Automating *that* is going to be interesting...  I've not given up, but it's
> not going to be fun ;-/
