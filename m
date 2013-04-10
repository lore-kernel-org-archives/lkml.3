Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937025Ab3DJJld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:41:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52552
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935192Ab3DJJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:41:31 -0400
Message-ID: <1365586878.30071.33.camel@laptop>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 11:41:18 +0200
In-Reply-To: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 10:23 -0500, Jacob Shin wrote:
> Upcoming AMD Family 16h Processors provide 4 new performance counters
> to count L2 related events. Similar to northbridge counters, these new
> counters are shared across multiple CPUs that share the same L2 cache.
> This patchset adds support for these new counters and enforces sharing
> by leveraging the existing sharing logic used for the northbridge
> counters.

If they're separate counters -- not shared with the regular cpu
counters like the 10h NB counters are, then they should have their own
PMU driver.

Similar to the 15h NB counters; which are a separate set of counters
and no longer overlay the normal counters.



