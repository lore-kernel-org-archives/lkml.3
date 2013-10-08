Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3JHNmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:42:55 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62285 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab3JHNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:42:53 -0400
Message-ID: <52540BD9.3000803@gmail.com>
Date: Tue, 08 Oct 2013 07:42:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using system
 wide or CPU options
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com> <1380400080-9211-3-git-send-email-dsahern@gmail.com> <87li2eofvd.fsf@sejong.aot.lge.com> <52497F3C.9070908@gmail.com> <20131008123928.GA4018@ghostprotocols.net> <525407D3.8060805@gmail.com> <20131008133325.GF4018@ghostprotocols.net>
In-Reply-To: <20131008133325.GF4018@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 7:33 AM, Arnaldo Carvalho de Melo wrote:
> [acme@zoo linux]$ perf stat non-existent-proggie
> non-existent-proggie: No such file or directory

ok. so this is a different error. need to detect the workload does not 
exist.

> Why should we report all those counters for something that wasn't found
> in PATH?
>
> We either report just the first line, with the errno, or that and the
> last, with how long it took to try to execute it, but that probably
> shouldn't be printed, as it is supposed to be how long the workload ran,
> right?

Right. need to feed/detect the exec failure back to the parent.

David
