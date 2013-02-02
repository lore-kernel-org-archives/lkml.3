Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3BBBf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 20:35:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:1660 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab3BBBfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 20:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,588,1355126400"; 
   d="scan'208";a="285658354"
Date: Fri, 1 Feb 2013 17:35:23 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf: add new uncore command
Message-ID: <20130202013523.GA2889@tassilo.jf.intel.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
 <878v78togq.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v78togq.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And there's a patchset [1] from Jiri to support some kind of formula -
> yeah, now I've written the correct spelling. :) - that might fit to this
> purpose if you provide suitable formula file IMHO.  So I guess we don't
> need to have another command and can reuse perf stat, no?

Yes with a proper expression engine it's all redundant. I haven't 
looked at Jiri's stuff in detail, but it seemed very simple-minded
and may not support all the computation needed.

Also would allow to finally replace the bogus perf stat -d frontend/backend
counters.

For stat there's no really a compelling reason to integrate
it, the usual wrappers work as well. They have the advantage that
they can be written in real programing languages, instead of trying
to invent a new one.

Expressions integrated would be mainly useful for things like
"counting perf top"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
