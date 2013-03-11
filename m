Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3CKJMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:12:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45956 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3CKJMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:12:23 -0400
Message-ID: <513D9FD9.6020507@parallels.com>
Date: Mon, 11 Mar 2013 13:11:53 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] posix timers: Extend kernel API to report more info about
 timers (v3)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Currently kernel doesn't provide any API for getting information about
what timers are currently created by process and in which state they 
are. Also, the way timer IDs are generated makes it impossible to create
a timer with any desired ID. Both facilities are very very tempting by
the checkpoint-restore project.

That said, this series fixes posix timers API in this way:

1. it makes timers IDs generation per-signal_struct to allow for
   recreation of a timer with desired ID;
2. it adds per-task proc file where all timers created by it are
   listed.

This v3 series is ported on v3.9-rc2 and patches' changelogs are fixed
according to Thomas' feedback to contain info why the change is required.

Thanks,
Pavel
