Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3CARj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:39:29 -0500
Received: from longford.logfs.org ([213.229.74.203]:58585 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3CARj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:39:28 -0500
Date: Fri, 1 Mar 2013 11:15:38 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
Message-ID: <20130301161538.GA16393@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-4-git-send-email-joern@logfs.org>
 <x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
 <20130301145805.GC30938@pd.tnic>
 <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49fw0f2m5r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 March 2013 10:08:00 -0500, Jeff Moyer wrote:
> 
> People don't just use this for "debugging sessions."  They use it in
> production, and I already gave you one reason why you might not want to
> do this with netconsole (udp is unreliable, and I've definitely seem
> cases where netconsole suffered due to dropped packets; this won't make
> that better, especially when you multiply the extra bytes times the
> number of servers on the subnet).

I think I maintain a fairly sizeable production setup with netconsole.
A few hundred machines run netconsole and send all messages to a
single recipient.  And all those machines have the patch we are
discussing applied.  That has caused roughly zero problems so far.

We constantly see problems with netconsole and presumably packet loss
(haven't checked yet) when show_state() runs.  That amount of load
appears to be too much for the network.  Regular production netconsole
is utterly unimpressed in my network, with or without CON_ALLDATA.

Which is not to say you are wrong.  It just means that noone has shown
an example supporting your argument yet, while I have one supporting
mine.

More fundamentally, I believe the console log levels used to make
sense when systems had exactly one console.  With multiple consoles
and vastly different properties of those consoles, you simply cannot
find one good answer for all.  A 9600 baud serial console will usually
add several seconds to your boot process, so eliminating extra
messages is hugely important.  Blockconsole can take several megabytes
a second without blinking, so the cost of extra messages is near-zero,
while the benefit remains identical.

Maybe the correct solution would be to have a separate loglevel for
each console.  I don't know.  For my purposes the coarser CON_ALLDATA
approach is good enough.

Jörn

--
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
