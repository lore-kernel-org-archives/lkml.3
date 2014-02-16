Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaBPUqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:46:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBPUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:46:33 -0500
Date: Sun, 16 Feb 2014 12:47:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Debabrata Banerjee <dbanerje@akamai.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, dbavatar@gmail.com, johunt@akamai.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] printk: Fix discarding of records
Message-ID: <20140216204754.GA16757@kroah.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 11:28:36AM -0800, Linus Torvalds wrote:
> Adding Kay and Greg, since the original code is from commit
> 7ff9554bb578 ("printk: convert byte-buffer to variable-length record
> buffer") and all the "prev" flag tweaks end up building on top of
> that.
> 
> The whole "prev flags" is messed up, and LOG_CONT is done very confusingly.
> 
> Why are *those* particular two "prev = msg->flags" incorrect, when
> every other case where we walk the messages they are required?
> 
> The code/logic makes no sense. You remove the "prev = msg->flags" at
> line 1070, when the *identical* loop just above it has it. So now the
> two loops count the number of characters differently. That makes no
> sense.
> 
> So I don't think this fixes the fundamental problem. I'm more inclined
> to believe that LOG_CONT is wrongly set somewhere, for example because
> a continuation wasn't actually originally printed due to coming from
> different users or something like that.
> 
> Or at the very least I want a coherent explanation why one loop would
> do this and the other would not, and why counting up *different*
> numbers could possibly make sense.
> 
> Because as it is, there clearly is some problem, but the patch does
> not look sensible to me.

Yeah, it doesn't make much sense to me either.

Kay had a printk() test module that would stress these types of paths
out a bunch, Kay, is that module around somewhere that we could maybe
add it to the kernel tree so it could be used to test changes like this?

thanks,

greg k-h
