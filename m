Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab3IZNfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:35:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36167 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3IZNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:34:58 -0400
Message-ID: <52443800.5080200@gmail.com>
Date: Thu, 26 Sep 2013 07:34:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: fix infinite loop with corrupted header
References: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
In-Reply-To: <1380172836-13936-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/13 11:20 PM, Sonny Rao wrote:
> We recently ran into a corrupt perf data file which mostly looked okay
> but the section size for data was set to 0.  This caused perf report to
> get into an infinite loop in __perf_session_process_events().  Let's
> just avoid this by bailing early and reporting it if there's an
> invalid header.

Been suggested before:
https://lkml.org/lkml/2013/5/9/405

Other changes went in around that time as well. Are you still seeing the 
loop on latest source?

David
