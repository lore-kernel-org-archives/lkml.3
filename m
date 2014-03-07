Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaCGSQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:16:50 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:42841 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbaCGSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:16:48 -0500
Date: Fri, 7 Mar 2014 12:16:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mike Travis <travis@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
In-Reply-To: <5317E33F.5000206@sgi.com>
Message-ID: <alpine.DEB.2.10.1403071214560.22377@nuc>
References: <20140214201841.826179349@linux.com> <20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org> <alpine.DEB.2.10.1403042130250.3742@nuc> <20140304200023.7b991909.akpm@linux-foundation.org>
 <alpine.DEB.2.10.1403051547140.16786@nuc> <5317E33F.5000206@sgi.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Mike Travis wrote:

> I haven't had much chance yet to look over your proposed changes but
> FYI, the counters are strictly feedback to insure that there are not
> unhandled NMI events from the perf subsystem.  The exact count is
> irrelevant.  IOW, counts in the double or triple digits is okay,
> counts > 100,000 is definitely not okay (there are multiple millions
> of perf events every 'perf top' refresh.)
>
> I'm not sure if this alters how you want to approach the changes.

Gotta patch here that converts all the atomic per cpu counters to int but
the local64_t definitions look very strange to me. I have never seen a
local64_t definition that is global and used for a counters. That can only
work if there is only one and exactly one processor that is modifying the
count.

