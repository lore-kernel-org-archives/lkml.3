Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3HFHkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:40:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37815 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3HFHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:40:20 -0400
Date: Tue, 6 Aug 2013 08:40:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Message-ID: <20130806074017.GB27005@ZenIV.linux.org.uk>
References: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
 <20130805225949.82a82dda.akpm@linux-foundation.org>
 <20130806064201.GR19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806064201.GR19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 08:42:01AM +0200, Andi Kleen wrote:
> On Mon, Aug 05, 2013 at 10:59:49PM -0700, Andrew Morton wrote:
> > On Mon,  5 Aug 2013 15:09:35 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Use standard gcc __attribute__((alias(foo))) to define
> > > the syscall aliases instead of custom assembler macros.
> > > 
> > > This is far cleaner, and also fixes my LTO kernel build.
> > 
> > I wonder what gcc version this was added in.  Seems fairly longstanding.
> 
> Seems to be already in 2.95, so every kernel compiler

IIRC, there had been some architectures where it didn't work correctly.
I don't remember details, though...   Geert?
