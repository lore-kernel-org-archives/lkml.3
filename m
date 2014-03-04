Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbaCDWfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:35:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbaCDWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:35:09 -0500
Message-ID: <531654D8.5040409@zytor.com>
Date: Tue, 04 Mar 2014 14:34:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Closing on the CR2 leak bug
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we need to get something into x86/urgent for the CR2 bug.

It seems like a no-brainer to do the hoisting patch, for which I prefer
the version proposed by Jiri Olsa which reads %cr2 and then passes it to
__do_page_fault() in a GPR:

http://lkml.kernel.org/r/20140228160526.GD1133@krava.brq.redhat.com

As fart as I can tell this should fix Vince's problem as well.

Anyone who objects to this?  Otherwise I will put it in tip:x86/urgent
tomorrow.

Do we need any more refinements this late in the -rc cycle?

	-hpa

