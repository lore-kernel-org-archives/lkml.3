Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaCaSAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:00:03 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:41388 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaCaR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:59:59 -0400
Message-Id: <20140331175407.400476950@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 31 Mar 2014 21:54:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org
Subject: [rfc 0/2] timerfd -- implement missing parts to checkpoint and restore timerfd state
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timerfd interface provides to user-space almost all data needed to checkpoint
and restore it, the only missing parts are @clockid (and while @ticks can be
read by simple read() call there is no way to write its value back). The series
exports them to userspace via /proc/pid/fdinfo/N interface and with write()
call one can setup @ticks back to a timer.

Please take a look. This is rfc to figure out if there a better way
to handle timerfds (maybe ioctls with complete timer context or somthing).
Also I'm not sure in one aspect -- if someone sets non-zero @ticks to
a timer, should I mark it as expired? Thomas, could you please give
me some advice on it?

	Cyrill
