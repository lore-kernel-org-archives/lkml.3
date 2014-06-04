Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaFDWbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:31:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:30291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaFDWbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:31:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,975,1392192000"; 
   d="scan'208";a="522854417"
Date: Wed, 4 Jun 2014 15:31:14 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools: perf: util: parse-events.c: Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140604223114.GC16855@tassilo.jf.intel.com>
References: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140604222047.GA16855@tassilo.jf.intel.com>
 <CAFo99gY_GZg7TY=H_UZBDL3dP2vL6NW-TCvtCDx+voY0uH80AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gY_GZg7TY=H_UZBDL3dP2vL6NW-TCvtCDx+voY0uH80AA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 12:23:55AM +0200, Rickard Strandqvist wrote:
> Hi
> 
> A little embarrassing, but I actually did not know that there was a
> better replacement for strncpy.

This works for perf, but not in general because standard glibc
does not have strlcpy. snprintf works always.

In practice if you could tolerate strncpy always zeroing
the complete string before you can also tolerate snprintf.

-Andi
