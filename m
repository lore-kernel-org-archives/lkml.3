Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbaAJAA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:00:27 -0500
Received: from forward19.mail.yandex.net ([95.108.253.144]:36085 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbaAJAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:00:24 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 19:00:24 EST
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: A feature suggestion for sandboxing processes
MIME-Version: 1.0
Message-Id: <223151389311706@web9g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 10 Jan 2014 01:55:06 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Fedora there is bin/sandbox command which runs a specified command in so called 'sandbox'. Program running in sandbox cannot open new files (it is commonly used with preopen stdin and stdout) and possibly its access to network is limited. It is intended to run potentially malicious software safely.

This Fedora sandbox is not perfect however.

One problem is:

Suppose the sandboxed program spawned some child processes and exited itself.

Suppose we want to kill the sandboxed program after 30 second, if it has not exited voluntarily.

The trouble is that the software cannot figure out which processes have appeared from the sandboxed binary. So we are unable to kill these processes automatically. This means that a hacker can in this way create thousands (or more) processes which would overload the system.

Also note that the sandboxed program may run setsid() and thus its identity may be lost completely.

I propose to add parameter sandbox_id to each process in the kernel. It would be 0 for normal processes and allocated like PID or GID for processes we create in sandbox. Children inherit sandbox_id. There should be an API call using which a process makes it sandboxed_id non-zero (which returns EPERM if it is already non-zero).

Then there should be API to enumerate all processes with given sandbox_id, so that we would be able to kill them (-TERM or -KILL). Or maybe we should also have the function which sends the given signal to all processes with given sandbox_id (otherwise we would war with a hacker which could possibly create new children faster than we kill them).

Please add me in CC: (I am not subscribed for this mailing list.)

-- 
Victor Porton - http://portonvictor.org
