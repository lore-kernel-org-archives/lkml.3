Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3JYJSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:18:51 -0400
Received: from imap.thunk.org ([74.207.234.97]:50532 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3JYJSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:18:50 -0400
Date: Fri, 25 Oct 2013 05:18:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: torvalds@linux-foundation.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131025091842.GA28681@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Artem S. Tashkinov" <t.artem@lycos.com>,
	torvalds@linux-foundation.org, fengguang.wu@intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 08:30:53AM +0000, Artem S. Tashkinov wrote:
> My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
> percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
> more) this value becomes unrealistic (13GB) and I've already had some
> unpleasant effects due to it.

What I think would make sense is to dynamically measure the speed of
writeback, so that we can set these limits as a function of the device
speed.  It's already the case that the writeback limits don't make
sense on a slow USB 2.0 storage stick; I suspect that for really huge
RAID arrays or very fast flash devices, it doesn't make much sense
either.

The problem is that if you have a system that has *both* a USB stick
_and_ a fast flash/RAID storage array both needing writeback, this
doesn't work well --- but what we have right now doesn't work all that
well anyway.

						- Ted
