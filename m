Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaGJSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:03:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:7905 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751919AbaGJSDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:03:53 -0400
Date: Thu, 10 Jul 2014 14:03:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Javi Merino" <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v5 09/10] thermal: add trace events to the power
 allocator governor
Message-ID: <20140710140350.5c75fee9@gandalf.local.home>
In-Reply-To: <20140710162014.GB2622@e104805>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
	<1405001928-12697-10-git-send-email-javi.merino@arm.com>
	<20140710114451.4bbf6785@gandalf.local.home>
	<20140710162014.GB2622@e104805>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 17:20:14 +0100
"Javi Merino" <javi.merino@arm.com> wrote:


> > 
> > How many CPUs are you saving load_cpu on? A trace event can't be bigger
> > than a page. And the data is actually a little less than that with the
> > required headers.
> 
> The biggest system I've tested it on is an 8 cpu system (with
> NR_CPUS==8).  So yes, small and we haven't seen any issues.
> 
> Are you saying that we are siphoning too much data through ftrace?  He
> find it really valuable to collect information during run and process
> it afterwards but I can see how this may not be feasible for systems
> with thousands of cpus.

Only too much for a single event. Perhaps have the tracepoint post per
CPU? Then you wouldn't need that array.

-- Steve
