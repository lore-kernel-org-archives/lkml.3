Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3KPAFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:05:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52707 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3KPAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:04:10 -0500
Date: Sat, 16 Nov 2013 00:04:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] coredumps truncated after "new helper: dump_align()"
Message-ID: <20131116000408.GK13318@ZenIV.linux.org.uk>
References: <11835033.kIc1RH0rS1@al>
 <20131115203838.GJ13318@ZenIV.linux.org.uk>
 <8708646.IsEyNQP0iB@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8708646.IsEyNQP0iB@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 10:34:43PM +0100, Peter Wu wrote:

> Unfortunately, this patch still does not fix the issue. I rm'd the output 
> directory just to be sure, but the bug is still there. What does this commit 
> do anyway? The commit message is quite vague.

Introduces a helper that used to be open-coded in a bunch of places -
pads the coredump to given alignment.  And switches those places
to that new helper...

FWIW, I haven't tried that on your config yet, but here (with the patch
in my previous mail) I'm seeing a sane-looking coredump -
-rw------- 1 root root 315392 Nov 15 17:48 core
Different userland, presumably, since that static binary is 684349
bytes long.

I'll try to reproduce with your config...
