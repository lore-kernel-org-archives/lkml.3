Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaIDTQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:16:42 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34057 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaIDTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:16:41 -0400
Date: Thu, 4 Sep 2014 12:14:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: task_numa_fault() && TASK_DEAD
In-Reply-To: <20140904103949.GA19300@redhat.com>
Message-ID: <alpine.LSU.2.11.1409041210400.12218@eggly.anvils>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com> <20140903160819.GA7682@redhat.com> <20140904071139.GH3190@worktop.ger.corp.intel.com> <20140904103949.GA19300@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Oleg Nesterov wrote:
> On 09/04, Peter Zijlstra wrote:
> > On Wed, Sep 03, 2014 at 06:08:19PM +0200, Oleg Nesterov wrote:
> >
> > > And a stupid (really, I don't understand this code) question:
> > >
> > > 	/* for example, ksmd faulting in a user's mm */
> > > 	if (!p->mm)
> > > 		return;

I don't understand your difficulty with that, I thought the comment
was helpful enough.  Does the original commit comment help?

commit 2832bc19f6668fd00116f61f821105040599ef8b
Author: Hugh Dickins <hughd@google.com>
Date:   Wed Dec 19 17:42:16 2012 -0800

    sched: numa: ksm: fix oops in task_numa_placment()
    
    task_numa_placement() oopsed on NULL p->mm when task_numa_fault() got
    called in the handling of break_ksm() for ksmd.  That might be a
    peculiar case, which perhaps KSM could takes steps to avoid? but it's
    more robust if task_numa_placement() allows for such a possibility.
