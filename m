Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936436Ab3DJRtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:49:04 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab3DJRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:49:03 -0400
Date: Wed, 10 Apr 2013 19:48:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
Message-ID: <20130410174859.GE16732@two.firstfloor.org>
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
 <51653C5D.4060408@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51653C5D.4060408@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My understanding is, that with -fnobuiltin, the compiler is not allowed
> to make assumptions about functions if it does not see their definition,
> even if they resemble standard functions. E.g. on x86_64, strlen() is
> out-of-line, so gcc would have to assume, that strcmp() has side
> effects. How about just naming the m68k inline function 'strlen'?

You should always supply an out of line fallback version with 
the standard name. The easiest way is to define the right
define so that lib/string.c does it.

-Andi
