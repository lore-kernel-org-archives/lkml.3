Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3JIQVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:21:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32854 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3JIQVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:21:19 -0400
Message-ID: <52558278.6080206@gmail.com>
Date: Wed, 09 Oct 2013 10:21:12 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        acme@redhat.com, ak@linux.intel.com, jolsa@redhat.com,
        hughd@google.com, keescook@chromium.org, akpm@linux-foundation.org
Subject: Re: [PATCH] perf: disable mmap2 support
References: <20131009161743.GA3022@quad>
In-Reply-To: <20131009161743.GA3022@quad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/13 10:17 AM, Stephane Eranian wrote:
>
> This patch disables the mmap2 record format support
> for now. The support needs a bit more work to cover
> VM_CLONE cases.
>
> The patch leaves attr->mmap2 defined, but returns
> an error if it is set. That ensures no PERF_RECORD_MMAP2
> record can be generated. Yet it minimizes the reverts in
> the perf tool.

The userspace code generates MMAP2 events for synthesized mmap events. 
That should be reverted to MMAP until the format of MMAP2 events is 
finalized.

David
