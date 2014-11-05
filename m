Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaKEPRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:17:46 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52720 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaKEPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:17:45 -0500
Message-Id: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
X-Sasl-Enc: F4eE2gP2/mwDag4A5f73RWc+CxDJ9NuotfgApkFXc6ce 1415200663
From: Martin Tournoij <martin@arp242.net>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-c51dec4f
Subject: [RFC] The SIGINFO signal from BSD
Date: Wed, 05 Nov 2014 16:17:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

As a long-time BSD user, I have become quite used to the SIGINFO (sent with ^t)
feature; after switching to Linux as my desktop a few months ago, I very much
miss this.

SIGINFO prints the status of the process to the terminal; BSD cp, for example,
shows show much data it's copied:

    $ cp large_file /dev/null
    <press ^t>
    load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k
    large_file -> /dev/null  15%

As you see, it shows the current load, pid, process status, memory usage, as
well as how much of the file has been copied. Many other BSD tools print similar
statistics (mv, tar, dd, sleep, fetch, etc.).

On Linux, sometimes SIGUSR1 is used for similar purposes, the problem with this
is that SIGUSR{1,2} will terminate a program if a program doesn't have a signal
handler installed(!)
SIGUSR1 also has no defined meaning, and may do something radically different;
nginx, for example, reopens the logfiles on SIGUSR1, and SIGUSR2 upgrades the
nginx executable on-the-fly.

So you need to carefully inspect the documentation, hope it's not out of date,
and then send SIGUSR1 and pray.

This is different from SIGINFO, which does nothing when it's not installed,
which is safe. You can send SIGINFO to any process, and not be afraid you kill
it.

In addition, it's also not easy to send SIGUSR1, you need to open a new
terminal, find the pid, and use a kill command (you could also use
pkill/killall, with the risk of sending the signal to other processes).

SIGINFO is, AFAIK, supported since 4.4BSD & descendants (ie. all modern BSD
systems), as well as MacOS X. Perhaps other systems as well (but did not
investigate).

Why don't we have SIGINFO on Linux? Would a patch to implement this be accepted?

SIGINFO is not defined in any standard, but Linux already implements other
useful non-standard signals (most notably SIGWINCH). IMHO it's a very useful
feature.

Thanks,
Martin

PS.
I am *not* subscribed to this maillist; please cc me in replies!
