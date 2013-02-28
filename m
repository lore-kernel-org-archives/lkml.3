Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3B1PsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:48:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3B1PsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:48:03 -0500
MIME-Version: 1.0
Date: Thu, 28 Feb 2013 23:48:00 +0800
Message-ID: <CACVXFVNzN721wGm96SroK6cm4E08gs+tJtELsHvxVTCXZtX95g@mail.gmail.com>
Subject: lockdep: access percpu variable too early
From: Ming Lei <ming.lei@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The percpu variables of 'lockdep_stats' and 'cpu_lock_stat'
may be accessed before percpu area is brought up in case of
CONFIG_DEBUG_LOCKDEP/CONFIG_LOCK_STAT, so these variables
in non-boot CPUs will be initialized incorrectly.

As far as I think of, there are several solutions for the
problem:

	1, just enable 'debug_locks' until percpu area is built
	2, define the two percpu variables in a simple/stupid
	percpu way inside lockdep
	3, clear these two percpu variables of non-boot CPUs
	just after percpu area is built.
	4, ignore the problem

Looks each approache have its own disadvantage, so what
is your opinion on the problem? or better approach?

Thanks,
--
Ming Lei
