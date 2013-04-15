Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3DOAvC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 20:51:02 -0400
Received: from dub0-omc1-s15.dub0.hotmail.com ([157.55.0.214]:33040 "EHLO
	dub0-omc1-s15.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753Ab3DOAvA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 20:51:00 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2013 20:51:00 EDT
X-EIP: [rvZLsrHoTbn6+HCKhBY+Iv1RcHaWE/U5]
X-Originating-Email: [josenavasmolina@hotmail.com]
Message-ID: <DUB114-W42B5E1E3DE755AB075F263BFCC0@phx.gbl>
From: Jose Navas <josenavasmolina@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Sleeping process from kernel space: not doing schedule?
Date: Mon, 15 Apr 2013 00:44:47 +0000
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Apr 2013 00:44:47.0362 (UTC) FILETIME=[6DECE620:01CE3972]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

First of all, I am not subscribed to the mailing list and I'd like to get the answers directly to my email. Thank you!

I am working on a project where I am trying to detect the Out Of Memory machine state and collect some data from the machine. I've created a LKM that hacks the do_brk call and checks if there is enough memory to perform the call. I successfully detect the OOM state and my next step is sending a signal to a process in user space that writes info to a log file (this way, I avoid the necessity of opening files in kernel space). After sending the signal, the LKM puts the current process to sleep, using the function schedule_timeout_uninterruptible(). What I expect, is to see the process in user space running some time while the process is sleeping, but, instead, I see that the user process do not run until the sleeping process has finished...

I'm suspecting that it is not doing scheduling or something similar. I'm missing something? Is this the correct way of putting a process to sleep from kernel space?

Thank you!!!

Jose 		 	   		  