Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaI2QmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:42:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52852 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbaI2Ql5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:41:57 -0400
Date: Mon, 29 Sep 2014 17:41:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] seq_file: Fix seq_putc() to be consistent with seq_puts()
Message-ID: <20140929164155.GI7996@ZenIV.linux.org.uk>
References: <20140926143721.52206f95@gandalf.local.home>
 <20140929144121.GA30562@pathway.suse.cz>
 <20140929154711.GF7996@ZenIV.linux.org.uk>
 <20140929120927.7e05f485@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929120927.7e05f485@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 12:09:27PM -0400, Steven Rostedt wrote:

> Note, I'm trying to make a seq_buf.c file that consolidates the code in
> trace_seq.c and seq_file.c. This will extend slightly the use cases of
> the seq_buf functions, but I think all the seq_*() functions from
> seq_file.c can be turned into functions that return void.

Umm...  seq_path() and friends might want to return real errors.
And seq_path_root() needs to be able to return SEQ_SKIP.
