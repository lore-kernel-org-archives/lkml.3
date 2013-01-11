Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3AKWgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:36:14 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62817 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AKWgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:36:13 -0500
Date: Fri, 11 Jan 2013 23:36:04 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Amit Kale <akale@stec-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Announcement: STEC EnhanceIO SSD caching software for Linux
 kernel
Message-ID: <20130111223604.GA14144@joi.lan>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 01:18:37AM +0800, Amit Kale wrote:
> Greetings,
> 
> STEC is happy to announce hosting of our EnhanceIO SSD caching software on github.
> We would like to invite kernel hackers to try it. We'll appreciate your
> valuable feedback to help us improve it to the standards of Linux kernel
> source code. We hope to eventually submit it for a possible inclusion in
> Linux kernel.

If you are serious about inclusion in Linux kernel sources, you may want to
act on these comments:
- kernel API wrappers should be removed
- your ioctl won't work with 32-bit userspace on 64-bit kernel (differences
  in size and padding of struct cache_rec_short fields)
- volatiles (probably) should go, see Documentation/volatile-considered-harmful.txt
- printk wrappers can be easily replaced by pr_debug/pr_info/etc
- the code should be more or less checkpatch.pl clean
- this is buggy: VERIFY(spin_is_locked((sl))); - spin_is_locked always returns
  0 on !CONFIG_SMP && !CONFIG_DEBUG_SPINLOCK

> (...)
> PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED
> 
> This electronic transmission, and any documents attached hereto, may contain
> confidential, proprietary and/or legally privileged information. The
> information is intended only for use by the recipient named above. If you
> received this electronic message in error, please notify the sender and delete
> the electronic message. Any disclosure, copying, distribution, or use of the
> contents of information received in error is strictly prohibited, and
> violators will be pursued legally.

FYI, most people are annoyed when they see those kind of threats on public
mailing lists...

Marcin
