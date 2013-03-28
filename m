Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3C1Pwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:52:37 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61782 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3C1Pwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:52:35 -0400
Date: Thu, 28 Mar 2013 16:52:29 +0100
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
Message-ID: <20130328155229.GP11449@rric.localhost>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <87d2uxje6u.fsf@sejong.aot.lge.com>
 <20130318084638.GC17959@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318084638.GC17959@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.13 09:46:38, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > So my question is how can an user know which persistent events are 
> > available in her system?
> 
> I think we need VFS enumeration for that: directories give a high level a 
> structure (allowing things like per user contexts) while readdir will give 
> list of specific persistent buffer contexts.
> 
> Sensible naming convention would be needed to make things easy to discover 
> and list - and for active buffers to not be forgotten about.
> 
> cgroups or a new 'eventfs' filesystem would be an option.

An option would be to attach the persistent events to a hosting pmu
(e.g. 'ras' in this case) and provide the events via sysfs as already
done by other pmus:

 /sys/bus/event_source/devices/ras/events/
 /sys/bus/event_source/devices/ras/events/mce_record
 ...

perf tools work then out-the-box with -e ras/mce_record/.

The event is selected by the 'ras' pmu and then routed to the original
pmu that might be e.g. 'tracepoint'. So we attach each persistent
event to a 'virtual' pmu which does the grouping in the perf sysfs and
the forwarding to its actual pmu.

-Robert
