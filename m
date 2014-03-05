Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbaCEV5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:57:32 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:41972
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbaCEV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:57:31 -0500
Date: Wed, 5 Mar 2014 15:57:28 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
In-Reply-To: <20140304200023.7b991909.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1403051547140.16786@nuc>
References: <20140214201841.826179349@linux.com> <20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org> <alpine.DEB.2.10.1403042130250.3742@nuc> <20140304200023.7b991909.akpm@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver seems to use local64_t to define a single static instance of a
counter and then seems to think that it is safe to increment the counter
from multiple processors using local64_inc and friends. Common
misunderstanding and a reason why I wanted the this_cpu operations.

The counters seem to be exported via module parameters.. So I guess we
need to define these per cpu and then sum them up when they need to be
displayed.

Dimitri?

Maybe lets move this outside of this patchset.

