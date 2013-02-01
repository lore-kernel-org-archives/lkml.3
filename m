Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3BANjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:39:21 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59239 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3BANjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:39:18 -0500
MIME-Version: 1.0
Date: Fri, 1 Feb 2013 15:39:16 +0200
Message-ID: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
Subject: clock_nanosleep() task_struct leak
From: Tommi Rantala <tt.rantala@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:

-----8<-----8<-----8<-----
#include <time.h>

static const struct timespec req;

int main(void) {
        return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
                        TIMER_ABSTIME, &req, NULL);
}
-----8<-----8<-----8<-----

Tommi
