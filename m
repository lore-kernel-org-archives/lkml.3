Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaGKI2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:28:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35722 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaGKI2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:28:00 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Fri, 11 Jul 2014 09:27:55 +0100
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20140711082755.GA2723@e104805>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
 <1405001928-12697-10-git-send-email-javi.merino@arm.com>
 <20140710114451.4bbf6785@gandalf.local.home>
 <20140710162014.GB2622@e104805>
 <20140710140350.5c75fee9@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140710140350.5c75fee9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 11 Jul 2014 08:27:56.0426 (UTC) FILETIME=[04368EA0:01CF9CE2]
X-MC-Unique: 114071109275803701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 07:03:50PM +0100, Steven Rostedt wrote:
> On Thu, 10 Jul 2014 17:20:14 +0100
> "Javi Merino" <javi.merino@arm.com> wrote:
> 
> 
> > > 
> > > How many CPUs are you saving load_cpu on? A trace event can't be bigger
> > > than a page. And the data is actually a little less than that with the
> > > required headers.
> > 
> > The biggest system I've tested it on is an 8 cpu system (with
> > NR_CPUS==8).  So yes, small and we haven't seen any issues.
> > 
> > Are you saying that we are siphoning too much data through ftrace?  He
> > find it really valuable to collect information during run and process
> > it afterwards but I can see how this may not be feasible for systems
> > with thousands of cpus.
> 
> Only too much for a single event. Perhaps have the tracepoint post per
> CPU? Then you wouldn't need that array.

Sounds good, I'll do that.

