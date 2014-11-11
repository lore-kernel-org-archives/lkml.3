Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaKKJh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:37:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:35889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKKJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:37:25 -0500
Date: Tue, 11 Nov 2014 10:37:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141111093719.GG10501@worktop.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107123431.GE3337@twins.programming.kicks-ass.net>
 <20141110213140.GG1292@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110213140.GG1292@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:31:40PM +0000, Matt Fleming wrote:
> Actually, yeah, that does look like it'd work. Are you OK with me adding
> an enum to the cqm_rmid_entry? You had concerns in the past about
> growing the size of the struct.

That was because I was thinking you did nr_rmid*sizeof(cqm_rmid_entry)
allocation, shortly thereafter I noticed you did a pointer alloc and
then allocated each individual entry.

Also, that enum can fit the hole you made there I think.
