Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3GEGyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:54:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43384 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:54:39 -0400
Date: Fri, 5 Jul 2013 08:54:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        dave.hansen@linux.intel.com, ak@linux.intel.com, jolsa@redhat.com
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
Message-ID: <20130705065435.GA6699@gmail.com>
References: <20130704223010.GA30625@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704223010.GA30625@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patch fixes a serious bug in:
> 
> commit 14c63f17b1fde5a575a28e96547a22b451c71fb5
> Author: Dave Hansen <dave.hansen@linux.intel.com>
> Date:   Fri Jun 21 08:51:36 2013 -0700
> 
>     perf: Drop sample rate when sampling is too slow
>     
> 
> There was an misunderstanding on the API of the do_div()
> macro. It returns the remainder of the division and this
> was not what the function expected leading to disabling the
> interrupt latency watchdog.
> 
> This patch also remove a duplicate assignment in
> perf_sample_event_took().
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks Stephane - I've applied this to perf/urgent and will get it to 
Linus ASAP.

	Ingo
