Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab3LXAal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:30:41 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44152 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3LXAaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:30:25 -0500
Message-ID: <52B8D582.9090009@gmail.com>
Date: Mon, 23 Dec 2013 19:29:54 -0500
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com> <20131220075759.GA12937@gmail.com> <20131223193757.GA1396@ghostprotocols.net>
In-Reply-To: <20131223193757.GA1396@ghostprotocols.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/13, 2:37 PM, Arnaldo Carvalho de Melo wrote:
> int perf_evlist__start_workload(struct perf_evlist *evlist)
> {
>          if (evlist->workload.cork_fd > 0) {
>                  char bf = 0;
>                  int ret;
>                  /*
>                   * Remove the cork, let it rip!
>                   */
>                  ret = write(evlist->workload.cork_fd, &bf, 1);
>                  if (ret < 0)
>                          perror("enable to write to pipe");
>
>                  close(evlist->workload.cork_fd);
>                  return ret;
>          }
>
>          return 0;
> }
>
> Ret there is 1, so we need to change it to:
>
> 		return ret != 1 ? -1 : 0;
>
> Right?

Yes, nice catch.

David

