Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3DRLKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:10:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43273 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3DRLKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:10:17 -0400
Message-ID: <1366283403.19383.2.camel@laptop>
Subject: Re: [RFC PATCH] perf: Update event buffer tail when overwriting old
 events
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Date: Thu, 18 Apr 2013 13:10:03 +0200
In-Reply-To: <1366005761-3685-1-git-send-email-zheng.z.yan@intel.com>
References: <1366005761-3685-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 14:02 +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> If perf event buffer is in overwrite mode, the kernel only updates
> the data head when it overwrites old samples. The program that owns
> the buffer need periodically check the buffer and update a variable
> that tracks the date tail. If the program fails to do this in time,
> the data tail can be overwritted by new samples. The program has to
> rewind the buffer because it does not know where is the first vaild
> sample.
> 
> This patch makes the kernel update the date tail when it overwrites
> old events. So the program that owns the event buffer can always
> read the latest samples. This is convenient for programs that use
> perf to do branch tracing. For example, debugger may want to know
> the latest branches before the ptrace event, but it doesn't care
> about old branchs samples.

The reason I've never done this is because it makes the fast path more
complex and expensive for arguably a corner case.

So if we're going to do this, you need strong arguments for why its
useful (this includes people actually using this etc..) and performance
data showing the impact of this change.

