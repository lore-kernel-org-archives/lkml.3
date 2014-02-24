Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaBXRgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:36:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaBXRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:36:51 -0500
Date: Mon, 24 Feb 2014 18:36:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: adrian.hunter@intel.com, acme@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [perf tool] record failure with 3.14-rc4
Message-ID: <20140224173639.GA7597@krava.brq.redhat.com>
References: <20140224172440.GF2553@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224172440.GF2553@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 05:24:41PM +0000, Will Deacon wrote:
> Hi guys,
> 
> If I try to run perf record as a non-root user, I end up with the following
> (unhelpful) error:
> 
>   $ perf record -e cycles ls
>   [...]
>   Not enough memory for reading perf file header
> 
> This is because the addresses in /proc/kallsyms always read as 0x0 when
> viewed by a non-privileged user, causing kallsyms__get_function_start to
> return 0x0 in args.start. machine__create_kernel_maps then treats this as
> an error an returns -1 to perf_session__create_kernel_maps, causing
> perf_session__new to fail and perf to exit.
> 
> The perf tool code in 3.13 is perfectly happy creating maps at 0x0, but I
> can see this has changed quite substantially in the recent merge window.
> 
> Any ideas? We could fix kallsyms__get_function_start to return < 0 on
> failure then fix the checks in the callers. Adrian?
hi,
not sure it's related, but i sent out rfc some time ago
for similar bad error messages:
  http://marc.info/?l=linux-kernel&m=138572558210216&w=2

maybe it could be updated for your case as well,
I'll try to check deeply later

jirka
