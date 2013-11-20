Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3KTOJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:09:43 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41357 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KTOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:09:40 -0500
Message-ID: <528CC2A2.6000403@gmail.com>
Date: Wed, 20 Nov 2013 07:09:38 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf script: Print callchains and symbols if they exist
 - v2
References: <1384920457-5986-1-git-send-email-dsahern@gmail.com> <20131120130426.GB308@localhost.localdomain>
In-Reply-To: <20131120130426.GB308@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13, 6:04 AM, Frederic Weisbecker wrote:

> We probably want to avoid DSO and IP for most tracepoints. For kernel
> tracepoints dso is going to be the kernel anyway and IP is often not that relevant
> either.

Sorry, you mentioned that last time and I forgot to respond.

Yes, there are a number of tracepoints that are completely kernel side 
and possibly uninteresting callstacks. There are others that are 
triggered in process context and you want to see the stacks all the way 
back to main. I would hope that users are adding -g to record only when 
it is truly wanted. Given that the idea of perf-script is to print data 
in a file why not dump everything in the file - address, dso, and 
symbol. There is always -G to suppress the callchains.

As an example it is useful to see the overhead of 'perf sched record 
-g': all I really want is callchains on sched_switch, and the callchains 
on sched_stat_runtime and wakeup are huge emphasizing the need to 
specify events where callchains are interesting and not collect them on 
others and that steps into the pandora's box of mixed sample types.

David

