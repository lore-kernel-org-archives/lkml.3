Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab3DIFDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:03:05 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60646 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3DIFDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:03:03 -0400
Date: Tue, 9 Apr 2013 07:02:50 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
Message-ID: <20130409050250.GA2499@netboy>
References: <515B0502.8070408@linaro.org>
 <1365009558.26858.19.camel@hornet>
 <515C66FE.7030501@linaro.org>
 <1365010502.26858.32.camel@hornet>
 <515C6C01.9070905@linaro.org>
 <1365092963.26858.107.camel@hornet>
 <1365185813.25942.12.camel@hornet>
 <20130406110507.GC7572@netboy>
 <1365443897.24306.12.camel@hornet>
 <51631510.6080401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51631510.6080401@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:05:52PM -0700, John Stultz wrote:
> 
> So thinking this through further, I'm worried we may _not_ be able
> to eventually enable this to be a vdso as I had earlier hoped.
> Mostly because I'm not sure how the fd -> file -> clock lookup could
> be done in userland (any ideas?).

How about a new clock operation, clock_install_vdso(), that lets the
process arrange for one dynamic clock to be reflected in its vdso
page?

Thanks,
Richard
