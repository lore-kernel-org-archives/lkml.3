Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaEONH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaEONH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:07:56 -0400
Date: Thu, 15 May 2014 15:07:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 08/20] perf tools: Allow hpp fields to be sort keys
Message-ID: <20140515130728.GE25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-9-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:41PM +0900, Namhyung Kim wrote:
> Add overhead{,_sys,_us,_guest_sys,_guest_us}, sample and period sort
> keys so that they can be selected with --sort/-s option.
> 
>   $ perf report -s period,comm --stdio
>   ...
>   # Overhead        Period          Command
>   # ........  ............  ...............
>   #
>       47.06%           152          swapper
>       13.93%            45  qemu-system-arm
>       12.38%            40         synergys
>        3.72%            12          firefox
>        2.48%             8            xchat
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/hist.c   |  9 +++++++--
>  tools/perf/util/sort.c | 39 +++++++++++++++++++++++++++++++++++++++

no documentation update.. Documentation/perf-report.txt

I wonder we want to update report's '-s' option help string.. it's already big ;-)

jirka
