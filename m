Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaFBQ5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:57:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:31953 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755420AbaFBQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:57:51 -0400
Date: Mon, 2 Jun 2014 12:57:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "Chen, Gong" <gong.chen@linux.intel.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140602125748.7093ced8@gandalf.local.home>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
	<20140530210759.267a854e@gandalf.local.home>
	<3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 16:22:19 +0000
"Luck, Tony" <tony.luck@intel.com> wrote:

 
> To which I'll counter that the trace ring buffer can handle tracing of
> events like page faults and context switches (can't it?) that happen
> at a rate of thousands per second.  Our eMCA records will normally
> happen at a rate of X per month (where X may well be less than one).
> If there is a storm of errors - we disable CMCI interrupts and revert
> to polling.  We declare a "storm" as just 15 events in a second. If we
> switch to polling, then we won't poll faster than once per second.
> 
> So worst case is that we are seeing some steady flow of events that
> don't quite trigger the storm detector ... about 14 events per second.

Also matters how big you expect these events to be. If you get a
"christmas tree" set of flags, how big will that event grow with all
the descriptions attached?

The max event size after all headers is 4056 bytes. If you go over
that, the event is ignored.

-- Steve
