Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3JCRWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:22:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32985 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3JCRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:22:29 -0400
Message-ID: <524DA7D2.80302@gmail.com>
Date: Thu, 03 Oct 2013 11:22:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: report user-friendly error from timechart
References: <1380791146-7465-1-git-send-email-artagnon@gmail.com> <20131003123820.GA12004@gmail.com> <524D7296.3090407@gmail.com> <20131003170802.GB2436@ghostprotocols.net>
In-Reply-To: <20131003170802.GB2436@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/13 11:08 AM, Arnaldo Carvalho de Melo wrote:

> And is_valid_tracepoint() is a too big hammer, it traverses the whole
> directory looking for a match instead of plain build the path and do an
> access, its one of those things I need to ditch at some point. So far I
> just try to do a perf_evlist__add_newtp and if it fails, look at errno.

And a number of tracepoints depend on CONFIG settings so it is more than 
just looking at whether debugfs is mounted and accessible/readable. 
e.g., look at the message I put into perf-lock

David

