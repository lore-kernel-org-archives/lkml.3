Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab3CGNiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:38:03 -0500
Received: from mail.renton.name ([90.155.165.44]:34995 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab3CGNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:45 -0500
Date: Thu, 7 Mar 2013 17:34:14 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
Message-ID: <20130307133414.GA6115@beaver>
References: <20130209141029.GA13493@beaver>
 <1360422473.6696.28.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360422473.6696.28.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 09, 2013 at 07:07:53AM -0800, Eric Dumazet wrote:
> >
> > I used 2.6.2x kernel for a long time on my shared hosting and I
> > didn't
> > have any problems. Kernels worked well and server uptime was about
> > 2-3
> > years.
> >
> > ...
> >
> > it doesn't happen on an empty server, only on loaded ones.
> > Unfortunately
> > I don't know how to provoke such hanging artificially.
> >

> Your traces dont contain symbols, its quite hard to guess the issue.

Well the server got high loaded and began to crash almost once a day.

=====
BUG: soft lockup - CPU#1 stuck for 23s! [httpd:21686]
Call Trace:
[<ffffffff8110bba5>] ? mntput_no_expire+0x25/0x170
[<ffffffff810f9389>] ? path_lookupat+0x189/0x890
[<ffffffff810f9b67>] ? filename_lookup.clone.39+0xd7/0xe0
[<ffffffff810fc85c>] ? user_path_at_empty+0x5c/0xb0
[<ffffffff8102b5f9>] ? __do_page_fault+0x1b9/0x480
[<ffffffff810f146e>] ? vfs_fstatat+0x3e/0x90
[<ffffffff810c54bf>] ? remove_vma+0x5f/0x70
[<ffffffff810f168f>] ? sys_newstat+0x1f/0x50
[<ffffffff814b09c2>] ? page_fault+0x22/0x30
[<ffffffff814b0f49>] ? system_call_fastpath+0x18/0x1d
=====

There's a full trace in attachment.

-- 
BRGDS. Alexey Vlasov.
