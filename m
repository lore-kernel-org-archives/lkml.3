Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3CAPIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3CAPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:08:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
	<1362087602-8979-4-git-send-email-joern@logfs.org>
	<x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
	<20130301145805.GC30938@pd.tnic>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 01 Mar 2013 10:08:00 -0500
In-Reply-To: <20130301145805.GC30938@pd.tnic> (Borislav Petkov's message of
	"Fri, 1 Mar 2013 15:58:06 +0100")
Message-ID: <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Fri, Mar 01, 2013 at 09:52:27AM -0500, Jeff Moyer wrote:
>> > For consoles like netconsole and blockconsole the loglevel filtering
>> > really doesn't make any sense.  If a line gets printed at all, please
>> > send it down to that console, no questions asked.
>> 
>> Could you please explain this a bit further?  Why wouldn't you want to
>> allow the admin to filter log messages to the block or network console?
>> This doesn't make a whole lot of sense to me, and in fact could cause
>> problems for netconsole now that you're potentially sending a ton more
>> traffic over the wire.
>
> Let's reverse the question: why would the admin ever want to filter
> messages to debugging consoles like netconsole or blockconsole?
>
> When running a debugging session, you generally want to see *all*
> messages.

People don't just use this for "debugging sessions."  They use it in
production, and I already gave you one reason why you might not want to
do this with netconsole (udp is unreliable, and I've definitely seem
cases where netconsole suffered due to dropped packets; this won't make
that better, especially when you multiply the extra bytes times the
number of servers on the subnet).

Cheers,
Jeff
