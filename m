Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaBORo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 12:44:27 -0500
Received: from one.firstfloor.org ([193.170.194.197]:44479 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaBORo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 12:44:26 -0500
Date: Sat, 15 Feb 2014 18:44:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        hjl.tools@gmail.com
Subject: Re: Updated Link-Time-Optimization patchkit
Message-ID: <20140215174424.GB32005@two.firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <20140215133814.GA287@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215133814.GA287@x4>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 02:38:14PM +0100, Markus Trippelsdorf wrote:
> On 2014.02.14 at 22:21 +0100, Andi Kleen wrote:
> > This is the updated LTO patchkit for 3.14-rc2.  LTO allows
> > the compiler to do global optimization over the whole kernel.
> 
> It is mildly annoying that one couldn't use vanilla binutils. Have you
> already opened bugs on sourceware.org/bugzilla/ to get this fixed for
> gold and ld.bfd?

The problem is supporting "pass through" of both pure (.S) assembler code and
LTO through ld -r, because the kernel makefiles use ld -r heavily.
Standard binutils would throw all the assembler away when in plugin LTO
mode.

HJ did the work (and fixed a couple other bugs that blocked kernel LTO),
but the mainline binutils people rejected the patches. You can judge
for yourself if their reasons make sense:

https://sourceware.org/ml/binutils/2012-05/msg00057.html

Noone has done the work for gold so far.

There was some effort from the Fedora binutils maintainers to add the
necessary patches to their version, but at least what is in FC20 doesn't
seem to be enough.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
