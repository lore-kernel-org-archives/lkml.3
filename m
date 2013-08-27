Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3H0MRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:17:52 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46274 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3H0MRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:17:50 -0400
Date: Tue, 27 Aug 2013 14:17:44 +0200
From: Robert Richter <rric@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130827121744.GE15884@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823100747.GC10223@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823100747.GC10223@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, 22 Aug 2013, Robert Richter wrote:
> > > This is for Linux man-pages:

Updated description below.

-Robert



Author: Robert Richter <robert.richter@linaro.org>
Date:   Tue Aug 13 11:22:22 2013 +0200

    [RFC] perf, persistent: ioctl functions to control persistency
    
    Implementing ioctl functions to control persistent events. There are
    functions to detach or attach an event to or from a process. The
    PERF_EVENT_IOC_DETACH ioctl call makes an event persistent. After
    closing the event's fd it runs then in the background of the system
    without the need of a controlling process. The perf_event_open()
    syscall can be used to reopen the event by any process. The
    PERF_EVENT_IOC_ATTACH ioctl attaches the event again so that it is
    removed after closing the event's fd.
    
    This is for Linux man-pages:
    
        type ...
    
            PERF_TYPE_PERSISTENT (Since Linux 3.xx)
    
                Open a persistent event that is already running in the
                background of the system. There is a unique identifier for
                each persistent event that needs to be specified in the
                event's attribute config field.  Persistent events are
                listed under:
    
                  /sys/bus/event_source/devices/persistent/
    
                See PERF_EVENT_IOC_DETACH how to create a persistent
                event. The instance creating such an event should also be
                responsible for removing it.
    
        ...
        persistent : 41, /* always-on event */
        ...
    
        persistent: (Since Linux 3.xx)
    
            Put event into persistent state after opening. After closing
            the event's fd the event is persistent in the system and
            continues to run.
    
        perf_event ioctl calls
    
            PERF_EVENT_IOC_DETACH (Since Linux 3.xx)
    
                Any event that was opened with the perf_event_open()
                syscall may become a persistent event. This is done by
                detaching the event from the controlling process that
                holds the event's file descriptor. This ioctl can be used
                for doing this. After detaching it, the event is
                persistent in the system. An unique identifier for the
                persistent event is returned or an error otherwise. After
                closing the fd the event will continue to run. The
                following allows to connect to the event again:
    
                    pe.type = PERF_TYPE_PERSISTENT;
                    pe.config = <pevent_id>;
                    ...
                    fd = perf_event_open(...);
    
                The event must be reopened on the same cpu.
    
            PERF_EVENT_IOC_ATTACH (Since Linux 3.xx)
    
                Attach the event specified by the file descriptor to the
                current process. The event is no longer persistent in the
                system and will be removed after all users disconnected
                from the event. Thus, if there are no other users the
                event will be closed too after closing its file
                descriptor, the event then no longer exists.
    
    Cc: Vince Weaver <vincent.weaver@maine.edu>
    Signed-off-by: Robert Richter <robert.richter@linaro.org>
    Signed-off-by: Robert Richter <rric@kernel.org>
