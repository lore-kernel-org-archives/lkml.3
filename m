Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746Ab3DDQKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:10:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468Ab3DDQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:10:53 -0400
Message-ID: <1365091846.2609.96.camel@laptop>
Subject: Re: [PATCH 4/6] perf: Fix hw breakpoints overflow period sampling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Date: Thu, 04 Apr 2013 18:10:46 +0200
In-Reply-To: <1362940871-24486-5-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
	 <1362940871-24486-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-10 at 19:41 +0100, Jiri Olsa wrote:
> The hw breakpoint pmu 'add' function is missing the
> period_left update needed for SW events.
> 
> The perf HW breakpoint events use SW events framework
> for to process the overflow, so it needs to be properly
> initialized during PMU 'add' method.

Yeah looks about right.. 

