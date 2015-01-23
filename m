Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbbAWSDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:03:48 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39933 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAWSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:03:46 -0500
From: Daniel Church <dchurch@andplus.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: [PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX
Date: Fri, 23 Jan 2015 13:03:29 -0500
Message-Id: <1422036211-10934-1-git-send-email-dchurch@andplus.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a timer overruns too many times before a call to timer_getoverrun the
overrun count can overflow and go negative.  POSIX.1-2001 specification
of timer_getoverrun() supports constant DELAYTIMER_MAX which prevents
overflow and caps overrun count.  Adds delaytimer_max value, caps
overrun count, and exposes value to userland via
/proc/sys/kernel/delaytimer_max.

Resolves https://bugzilla.kernel.org/show_bug.cgi?id=12665 - POSIX timers API does not support DELAYTIMER_MAX

