Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3BGRpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:45:08 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:62861 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3BGRpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360256627.2621.77.camel@gandalf.local.home>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<20130207111025.GD8945@gmail.com>
	<CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
	<1360255280.2621.70.camel@gandalf.local.home>
	<CAFTL4hy-hz=okOC7mWTwP=eh_OrL48c5hoLuXyBRFMAgquLCtw@mail.gmail.com>
	<1360256627.2621.77.camel@gandalf.local.home>
Date: Thu, 7 Feb 2013 18:45:04 +0100
Message-ID: <CAFTL4hyALkyoG640cyPfBG8ym_MeYWfje4oG4966pmXJhickZA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2013-02-07 at 17:45 +0100, Frederic Weisbecker wrote:
>
>> >
>> > config NO_HZ_TASK
>> >         bool "Stop tick on specified CPUs when single task is running"
>> >         default n
>> >         depends on NO_HZ
>>
>> Ok I launched another debate about that single task thing. I wish we
>> don't make it a fundamental component but rather an implementation
>> detail that can be dynamically dealt with in the future.
>
> It's not just an implementation detail, as it is very visible to the
> user. If they want to take advantage of a task NO_HZ they have to go
> through a bit of loops to make sure only a single task is running on a
> CPU. We should be broadcasting this requirement to educate the users on
> exactly how they can take advantage of this feature.

If you guys really insist I can make it CONFIG_NO_HZ_SINGLETASK. I
don't mind that much. Then when we support hrtick we can rename it to
NO_HZ_FULL or whatever.
