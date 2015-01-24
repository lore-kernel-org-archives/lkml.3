Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbbAXRtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:49:24 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:52296 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbbAXRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:49:21 -0500
From: Daniel Church <dchurch@andplus.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: [PATCH v2 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX
Date: Sat, 24 Jan 2015 12:48:55 -0500
Message-Id: <1422121737-3686-1-git-send-email-dchurch@andplus.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX>
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX>
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

v2: Consolidates overflow logic into helper function as suggested by Thomas Gleixner <tglx@linutronix.de>

