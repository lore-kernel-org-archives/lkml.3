Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3LSCC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:02:57 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:45391 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3LSCCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:02:55 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Dec 2013 18:02:34 -0800
Message-ID: <CALCETrVmWAVwLtEbK0AZGBmcqUEkM_Zhz1WGSY5wSpLsaHiOkA@mail.gmail.com>
Subject: Possible SNB throttling erratum in need of workaround?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a box running 3.9.4.  For a few hundred ms, all packages and
cores* exceeded their power limits, and then they all came back to
normal.

Since then, turbo boost went away.

The first thing I tried was writing 0 to msr 0x19C to clear the
throttling "log" bit.  The bit was clear, but still no turbo.  (I only
did this on one package to avoid destroying information.)

I have the performance governor set, so there are never any
software-initiated performance transitions.  As an experiment, I
switched core 0 to powersave (aka very low frequency) and then back to
performance.  The entire package's turbo came back.  I did the same
thing to the cores on package 1 (all of them, sorry), and that
package's turbo boost came back.

Does the kernel need to reprogram CPU frequencies after thermal/power
throttling conditions clear?

My CPUs are:

processor       : 31
vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-2690 0 @ 2.90GHz
stepping        : 7
microcode       : 0x710


* Slight lie here.  CPU18 exceeded core limit but not power limit.
