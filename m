Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3JKNcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:32:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:16942 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3JKNcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1080,1371106800"; 
   d="scan'208";a="415486863"
Message-ID: <1381498368.19281.15.camel@empanada>
Subject: Re: [PATCH v10 12/12] tracing: define trace_dump_stack() if
 !CONFIG_STACKTRACE
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Oct 2013 08:32:48 -0500
In-Reply-To: <5257F666.7080703@hitachi.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
	 <b88c6631dc9bdd143e5fc19341954e42e59de128.1381445299.git.tom.zanussi@linux.intel.com>
	 <5257F666.7080703@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 22:00 +0900, Masami Hiramatsu wrote:
> (2013/10/11 9:48), Tom Zanussi wrote:
> > If CONFIG_STACKTRACE is turned off, trace_dump_stack() isn't defined,
> > resulting in an 'undefined reference' error - define a stub to remedy
> > that.
> > 
> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> 
> Hmm, what kernel config caused that error?
> It seems that the CONFIG_STACKTRACE is forced on if it is required.
> And if you have found such case, IMHO, we should turn on the CONFIG_STACKTRACE
> in Kconfig.

Yeah, it's not easy to turn off CONFIG_STACKTRACE - I basically had to
tweak a couple Kconfigs to do it, so I could test my stacktrace trigger
CONFIG_STACKTRACE ifdefs.

Still, it's code that explicitly depends on CONFIG_STACKTRACE, so I
think it makes sense to ifdef it.

Tom

> (Also, if it is not related to this series, it should be reported as a separated
> bugfix :) )
> 
> Thank you,
> 
> 


