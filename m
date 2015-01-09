Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbbAIQ0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:26:06 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:62714 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbbAIQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:26:04 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 9 Jan 2015 11:26:54 -0500 (EST)
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: PERF_FLAG_FD_OUTPUT has been broken since 2.6.35
In-Reply-To: <20150109160051.GK29390@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1501091123040.27178@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501081014460.24664@vincent-weaver-1.umelst.maine.edu> <20150109160051.GK29390@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 Jan 2015, Peter Zijlstra wrote:
> > So is this worth fixing seeing as apparently no one uses this feature?
> 
> I think there's a fair argument for removing it, Ingo, Acme?

could the functionality be replaced with a subsequent call to
	ioctl(PERF_EVENT_IOC_SET_OUTPUT)
?

Although I suppose there's a possibility for losing a small amount of data 
or some other reason that PERF_FLAG_FD_OUTPUT was introduced in the first 
place.

In addition, if we remove PERF_FLAG_FD_OUTPUT would there then be any 
reason to keep PERF_FLAG_FD_NO_GROUP around?

Vince
