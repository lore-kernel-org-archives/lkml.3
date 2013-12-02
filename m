Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3LBTD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:03:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7858 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751975Ab3LBTDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:03:25 -0500
Date: Mon, 2 Dec 2013 14:03:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC] Packaging libtraceevent.so
Message-ID: <20131202140322.4ad6a151@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

The question has recently come up in Fedora about packaging the
libtraceevent.so library. Currently there's 4 users of it:

 1) perf
 2) trace-cmd
 3) powertop
 4) rasdaemon

But each have their own copy of the code.

Both perf and trace-cmd are the major developers of the package, and I
would recommend that they continue using the *.a version, but for those
tools that are simple users of the library, it would probably make
sense to have them use libtraceevent.so and remove their copies from
the code (powertop and rasdaemon).

The question that I'm posing here is, what currently needs to be done
to have this happen?

Is the API stable enough for a release?

We probably should have a dot versioning with the .so (ie.
libtraceevent.so.1)

So what are people's thoughts on this topic?

-- Steve
