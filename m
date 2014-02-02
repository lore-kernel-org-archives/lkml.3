Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaBBCcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:32:53 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44794 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaBBCcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:32:52 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 1 Feb 2014 18:32:31 -0800
Message-ID: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
Subject: Why is syscall auditing on with no rules?
To: Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a stock Fedora installation:

$ sudo auditctl -l
No rules

Nonetheless TIF_SYSCALL_AUDIT is set and the __audit_syscall_entry and
__audit_syscall_exit account for >20% of syscall overhead according to
perf.

This sucks.  Unless I'm missing something, syscall auditing is *off*.

How hard would it be to arrange for TIF_SYSCALL_AUDIT to be cleared
when there are no syscall rules?

(This is extra bad in kernels before 3.13, where the clear call for
TIF_SYSCALL_AUDIT was completely missing.)

--Andy
