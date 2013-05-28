Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab3E1IZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:25:36 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:46176 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3E1IZb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 28 May 2013 04:25:31 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 04:25:31 EDT
Message-Id: <51A484C1020000A100011125@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 28 May 2013 10:19:45 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: bad time after boot (read from absent hardware?): "Time:
 165:165:165  Date: 165/165/65"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Some time ago I discovered strange output in boot messages, just as if the kernel trusts junk from hardware that is not present, like the RTC in a paravirtualized Xen guest (the guest has no /dev/rtc*). The message says:
<6>[    0.123524] Time: 165:165:165  Date: 165/165/65

Obviously, if there were some validity check, this wouldn't pass, so I guess there is none!

In Xen's message buffer (hypervisor) I only see this error (that seems unrelated):
(XEN) mm.c:833:d6 Non-privileged (6) attempt to map I/O space 000000f0

According to my source code the print originates from read_magic_time() in /drivers/base/power/trace.c.

I'm running kernel 3.0.74-0.6.8-xen (SLES11 SP2) on x86_64.

Regards,
Ulrich


