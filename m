Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3EMOLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:11:20 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40590 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3EMOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:11:19 -0400
Date: Mon, 13 May 2013 16:11:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] perf report: Add --percent-limit option
Message-ID: <20130513141117.GC17814@two.firstfloor.org>
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:41:42PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The --percent-limit option is for not showing small overheaded entries
> in the output.  Maybe we want to set a certain default value like 0.1.
> 
> Cc: Andi Kleen <andi@firstfloor.org>

I like the option, but 0 is not a good default.
Make it 1 or something.

Perhaps a better heuristic would be 
percent < threshold || samples < sample-threshold
with sample-threshold being several hundred at least.

A very small number of hits on something is usually quite much useless,
unless your original event was extremly rare in the beginning
(but then it's unclear if the profile is any useful)

-Andi

