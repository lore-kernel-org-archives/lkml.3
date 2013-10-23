Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3JWNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:16:56 -0400
Received: from mail-gg0-f172.google.com ([209.85.161.172]:61085 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3JWNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:16:53 -0400
Date: Wed, 23 Oct 2013 10:16:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 11/14] perf sched: Make struct perf_sched sched a
 local variable
Message-ID: <20131023131646.GA14490@ghostprotocols.net>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
 <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
 <5267702B.6080104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267702B.6080104@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 23, 2013 at 07:43:55AM +0100, David Ahern escreveu:
> On 10/22/13 8:34 AM, Adrian Hunter wrote:
> >Change "struct perf_sched sched" from being global to being local.

> Acked-by: David Ahern <dsahern@gmail.com>

Hey guys, this is essentially a revert of:

commit f36f83f947ede547833e462696893f866df77324
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Tue Jun 4 14:46:19 2013 +0900

    perf sched: Move struct perf_sched definition out of cmd_sched()
    
    For some reason it consumed quite amount of compile time when declared
    as local variable, and it disappeared when moved out of the function.
    Moving other variables/tables didn't help.
    
    On my system this single-file-change build time reduced from 11s to 3s.
-----

- Arnaldo
