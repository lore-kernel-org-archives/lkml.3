Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3CLBOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:14:08 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:56656 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3CLBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:14:06 -0400
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 09:14:03 +0800
Message-ID: <CAJtEV7ZsOd=c6_+A3W+NYBtrWAUPH7NrVEk-J+_+ZgoJQTBZVg@mail.gmail.com>
Subject: Bug involving dynamic_debug and '-p' modifier
From: Andrew Cooks <acooks@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason

When I specify a '-p' modifier in the dynamic debug options in the
kernel command line, I get a kernel panic during boot. The panic
happens after userspace starts doing graphical stuff, but I haven't
been able to pinpoint exactly what.

If I use '=_' instead of '-p', or boot to a recovery mode, or change
the modifier after booting using debugfs, the panic doesn't occur. For
example, booting to runlevel 3 with '=_', then flipping the same
modifier to first to '+p' and then to '-p', before starting X does not
result in a panic.

Booting to runlevel 3 (or even 1!), with '-p' results in a panic, but
'rdshell' is OK.

I also tried the Red Hat kernel (just because it's installed - I
haven't figured out how to tell the package manager that I don't want
a kernel). This also panics, but it says that '-p' is not supported.

Please let me know if you need me to do any other tests.

'-p', panic: http://pastebin.com/8yAcBQdY
'-p', rdshell, no panic: http://pastebin.com/Hi2a7BZA

--
a.
