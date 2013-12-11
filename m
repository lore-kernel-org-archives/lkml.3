Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3LKWQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:16:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:27426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3LKWQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:16:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,874,1378882800"; 
   d="scan'208";a="450801145"
Date: Wed, 11 Dec 2013 14:16:50 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/38] perf tools: Use asprintf instead of malloc plus
 snprintf
Message-ID: <20131211221650.GP22695@tassilo.jf.intel.com>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <1386187622-2928-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386187622-2928-2-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 05:06:25PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> The asprintf library function is equivalent to malloc plus snprintf so
> use it because it is simpler.

I used to be very fond of asprintf too, but apparently there are some 
really ancient glibc versions that implement it incorrectly.
I had to remove it from mcelog at some point because of that.

No need to yank it out, but just to let you know.

-Andi
