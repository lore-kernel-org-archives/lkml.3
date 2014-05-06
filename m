Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaEFSu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:50:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47779 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbaEFSu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:50:56 -0400
Date: Tue, 6 May 2014 20:50:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140506185050.GD25013@pd.tnic>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <20140506123907.GV32718@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140506123907.GV32718@rric.localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:39:07PM +0200, Robert Richter wrote:
> Creation of events basically does (function arguments are a bit pseudo
> code):
> 
> 	attr.type   = pmu_type;
> 	attr.config = event_config;
> 	event = perf_event_open(attr, cpu, ...);
> 	id = ioctl(event, PERF_EVENT_IOC_UNCLAIM, 0);

Remind me again pls why we decided for the CLAIM/UNCLAIM part? It is
very unintuitive. What was against we detach from the event (we're
implicitly attached to it in the normal case, when it is not persistent)
and then reattach?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
