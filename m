Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaFUNac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:30:32 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60241 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaFUNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:30:30 -0400
MIME-Version: 1.0
Date: Sat, 21 Jun 2014 09:30:30 -0400
X-Google-Sender-Auth: CPQ-IZ5ru7tn6GOaxNYCCsAIIEY
Message-ID: <CA+5PVA61wwmnstiBdDemufGvXvSu4RL3WHds3NSstH-rVx7tYg@mail.gmail.com>
Subject: More 3.16 vdso fallout
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a report[1] of d-bus getting a SEGV only on i686 machines
with the 3.16 kernel.  It's a bit light on specifics, but the relevant
detail seems to be:

"I'm pretty sure kernel is to blame here.

The crash occurs when signal handler for RT signal 33 (used internaly
by NPTL/pthreads) returns to address zero (not sure why).

This only happens with 3.16 kernel, works fine with 3.15."

and

"Seems to be related to v3.16's arch/x86 VDSO changes. Works fine when
booting with vdso=0."

There isn't an actual backtrace for the SEGV in the bug, but we can
ask for one.  The kernels in question should be very recent, but lack
the 5 patch series Andy recently sent as those aren't in Linus' tree
yet.  Not sure if those would impact anything or not.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1110968
