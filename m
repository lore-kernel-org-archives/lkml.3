Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3ILNep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:34:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44512 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3ILNen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:34:43 -0400
Message-ID: <5231C2EF.8080200@gmail.com>
Date: Thu, 12 Sep 2013 06:34:39 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>
Subject: Re: [PATCH 14/16] perf kvm: reuse some code of perf_kvm__timerfd_create()
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com> <1369527896-3650-15-git-send-email-dsahern@gmail.com> <20130912130849.GA23826@gmail.com>
In-Reply-To: <20130912130849.GA23826@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/13 6:08 AM, Ingo Molnar wrote:
>
> btw., I tried to build perf on a really old distro that has no timerfd.h,
> and got:

Right. I hit that last week or so with RHEL5 as a build server.

timerfd was introduced before perf so any system with perf capability 
will also have timerfd. So the problem is strictly building perf on an 
older system. Are you using a tarball created by one of the 'make 
perf-*' options? Is the expectation that the resulting perf binary will 
be used for both record and report paths?

I could compile out the feature if timerfd is not available or add a 
compat layer in perf (e.g., if not defined, define it).

David
