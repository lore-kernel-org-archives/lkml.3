Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3JYTWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:22:09 -0400
Received: from 87-127-191-49.static.enta.net ([87.127.191.49]:45104 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3JYTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:22:07 -0400
Date: Fri, 25 Oct 2013 20:22:05 +0100
From: Nick Warne <nick@linicks.net>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Rollback FS
Message-ID: <20131025192205.GA15583@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Recently, I just do some stupid stuffs as follows.
>
> # mv /lib/x86_64-linux-gnu/libc.so.6  /tmp
>
> After move "/lib/x86_64-linux-gnu/libc.so.6" away, you could not run lots
> of commands, which show you some errors like this.
>
> # ls
> ls: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory
> # mv
> mv: error while loading shared libraries: libc.so.6: cannot open
> shared object file: No such file or directory

Well we all do stupid things sometimes... I done similar to you once, but copied (and overwrote) a different version trying to fix something...

/sbin/sln is your friend (if you don't panic when it happens).  No need for a large vfs to monitor user errors like this.

/sbin/sln is a statically built ln, so you can symlink back the file to get userspace going, then copy the file (fix it) back properly.

Nick
-- 
FSF Associate Member 5508
http://linicks.net/
