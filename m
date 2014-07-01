Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaGAIOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:14:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaGAIOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:14:31 -0400
Date: Tue, 1 Jul 2014 10:14:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "HATAYAMA, Daisuke" <d.hatayama@jp.fujitsu.com>, hpa@zytor.com,
        Don Zickus <dzickus@redhat.com>, matt@console-pimps.org,
        acme@kernel.org, mingo@redhat.com, paulus@samba.org,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
Message-ID: <20140701081413.GJ6758@twins.programming.kicks-ass.net>
References: <20140613084437.12424.62294.stgit@localhost6.localdomain6>
 <20140616153047.GJ177152@redhat.com>
 <53B12CB3.5050508@jp.fujitsu.com>
 <20140630222224.GH19781@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630222224.GH19781@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:22:24PM -0700, Andi Kleen wrote:
> > 
> > I'm also interested in the behaviour of CondChgd bit on Ivy Bridge processors.
> 
> The intended meaning of CondChgd is that a hardware debugger has taken over the
> PMU. It shouldn't really be set in other circumstances.

The SDM utterly and totally fails to mention this, please fix that.

> I think right now for perf it would be best to just ignore it.
> 
> In theory could stop using the PMU, but if some BIOS set it it would
> completely disable perf there. So better to just ignore it.

The even better option would be to kill off SMM mode, all that ever does
is create problems.
