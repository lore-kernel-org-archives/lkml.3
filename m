Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaAYWCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 17:02:03 -0500
Received: from mail-oa0-f67.google.com ([209.85.219.67]:53437 "EHLO
	mail-oa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaAYWCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 17:02:01 -0500
From: "Network Nut" <sillystack@gmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: WaitForMultipleObjects/etc. In Kernel
Date: Sat, 25 Jan 2014 16:01:53 -0600
Message-ID: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac8aGPoR6zLRzcPoSoO7y+ylNcQ9tA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is my first post to anything Linux, so if there is a better mailing
list, please let me know.

I think that the facility by which a thread can block while waiting for any
of several synchronization primitives (*mutex*, *semaphore*, *event*,
*waitable
timer*)...is not only "nice to have", but fundamental to complex (clean)
multi-threaded programming. Of course, this facility is available on
Windows as *WaitForMultipleObjects *with all the associated functions.

That said, I have a C++ project on Windows that is nearly 100% portable.
The part that is not portable is mostly the synchronization elements. Every
year or so I take a cursory look at Linux's (Unix's) synchronization model,
and the process thread model, and...I guess you have heard it before - it's
simply not the same.

I have also seen various attempts on the web to create wrapper functions
that provide a Windows synchro API on Linux, but again, the result is never
quite the same. IBM, in their attempt and exposition, admits this. It is
clear, at least to me, that if one wants true ability to wait for any of
the various synchronization objects simultaneously, there needs to be
deliberate, explicit kernel support.

I was wondering:

   1. What is the likelihood that the guardians of the kernel would even
   allow something so fundamentally different inside?
   2. My gut feeling is that adding such support would fundamentally change


   other aspects of Linux. For example, I am vaguely familiar with asio, but
   to do it the way it was done in Windows...

Finally, this is not a situation where the end-game is having a kernel of
my own that has such support. Support would need to be pre-existing for the
users of my project.

Please note that I am not a Windows bigot trying to impose a
Microsoft-centric world-view on Linux. I think this facility transcends any
particular OS, and I feel that it is merely fortunate coincidence that the
Microsoft (DEC) engineers had the inclination to do it.

-Nut

