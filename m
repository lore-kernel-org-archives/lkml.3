Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab3IZNqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:46:50 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43813 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3IZNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:46:45 -0400
Date: Thu, 26 Sep 2013 10:46:40 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
Message-ID: <20130926134640.GA26159@ghostprotocols.net>
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
 <52443800.5080200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52443800.5080200@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 26, 2013 at 07:34:56AM -0600, David Ahern escreveu:
> On 9/25/13 11:20 PM, Sonny Rao wrote:
> >We recently ran into a corrupt perf data file which mostly looked okay
> >but the section size for data was set to 0.  This caused perf report to
> >get into an infinite loop in __perf_session_process_events().  Let's
> >just avoid this by bailing early and reporting it if there's an
> >invalid header.
> 
> Been suggested before:
> https://lkml.org/lkml/2013/5/9/405

Thanks for the pointer (and this latest patch as well), looking at it
now.

- Arnaldo
 
> Other changes went in around that time as well. Are you still seeing
> the loop on latest source?
> 
> David
