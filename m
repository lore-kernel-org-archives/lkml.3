Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab3KMLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:39:44 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:55016 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab3KMLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:39:42 -0500
Date: Wed, 13 Nov 2013 06:39:27 -0500
From: Matthew Whitehead <tedheadster@gmail.com>
To: john.stultz@linaro.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, mwhitehe@redhat.com
Subject: nohz problem with idle time on old hardware
Message-ID: <20131113113927.GA13875@mwhitehe.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing the 3.12 kernel on some _old_ hardware and I uncovered a bug.
It arises when nohz=on and goes away with nohz=off. On a crusty dual Pentium-1 
system that is completely idle, the sar utility reports 0% idle time on cpu0 
and 100% idle on cpu1. Cpu0 _should_ also be reporting 100% idle, but instead
it reports around 75% system time and 25% user time.

The problem was diagnosed by Steve Rostedt with help from John Stultz. The old
system declares the dual TSCs unstable, and backs down to a timesource of 
refined-jiffies. Apparently refined-jiffies and jiffies are not a usable 
timesourcefor nohz, but we don't check for that case because most modern
systems have several reliable hardware timesources.

John suggested that we turn off nohz unless a usable hardware timesource is
present.

- Matthew Whitehead <tedheadster@gmail.com>

