Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3IEEUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:20:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58741 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IEEUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:20:03 -0400
Date: Thu, 5 Sep 2013 05:20:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Scott J Norton <scott.norton@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
Message-ID: <20130905041959.GN13318@ZenIV.linux.org.uk>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
 <20130904191104.GK13318@ZenIV.linux.org.uk>
 <CA+55aFwW+hWwQd8+NgukSidHbf2bnd6QO0yKK9NAgX+9rt0cOQ@mail.gmail.com>
 <5227E321.4090008@hp.com>
 <CA+55aFyURmAMo1Hso1_2zzcNEfcqOLUyhLGrBhvtMXWMJHVMfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyURmAMo1Hso1_2zzcNEfcqOLUyhLGrBhvtMXWMJHVMfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 07:48:14PM -0700, Linus Torvalds wrote:
>  - use the name length as a maximum
> 
>  - do a byte-at-a-time copy, stopping at a zero (it's going to be
> faster than memchr anyway)
> 
> Then, later on, we can do one that does a word-at-a-time using the
> CONFIG_DCACHE_WORD_ACCESS magic: we know dentry names are always
> word-aligned, and we have an efficient "has_zero()" function for
> finding zero bytes in a word.

Umm...  Dentry names are word-aligned, but the place where we copy them
doesn't have to be.  OTOH, DCACHE_WORD_ACCESS is for architectures where
unaligned stores are fine, so...
