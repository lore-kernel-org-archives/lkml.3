Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbbAPQYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:24:06 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57602 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbbAPQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:24:05 -0500
Date: Fri, 16 Jan 2015 11:23:57 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Issue with 'lib/vsprintf.c: don't try to fix pointer wrap-around'
Message-ID: <20150116162357.GA10859@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rasmus,

I have trouble booting my test machine with this patch in -mm:

commit bb2e066c6943e62e9650bb129f416dacf138f8b1
Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Wed Jan 14 01:00:44 2015 +0000

    lib/vsprintf.c: don't try to fix pointer wrap-around
    
    Actual kernel buffers can't wrap into the user address space.  If someone
    manages to pass a buf/size combination that wraps, it is most likely due
    to a bug in the caller.  Instead of trying to fix it by using a smaller
    part of the buffer, bail out.
    
    Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
    Cc: Jiri Kosina <jkosina@suse.cz>
    Cc: Randy Dunlap <rdunlap@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

After I get "Loading bzImage-new... ok" from the bootloader, the
serial console remains quiet.

A WARN_ON_ONCE() inside vsnprintf() looks like it would deadlock
instantly when triggering this overflow from printk(), no?
