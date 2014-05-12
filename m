Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaELQBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:01:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48477 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbaELQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:01:17 -0400
Date: Mon, 12 May 2014 16:58:11 +0100
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/8] ftrace: make CALLER_ADDRx macros more generic
Message-ID: <20140512155811.GB4880@arm.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
 <20140502151957.6978d870@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502151957.6978d870@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Fri, May 02, 2014 at 08:19:57PM +0100, Steven Rostedt wrote:
> On Wed, 30 Apr 2014 18:54:29 +0900
> AKASHI Takahiro <takahiro.akashi@linaro.org> wrote:
> 
> > Most archs with HAVE_ARCH_CALLER_ADDR have the almost same definitions
> > of CALLER_ADDRx(n), and so put them into linux/ftrace.h.
> 
> Please add a bit more to the change log. Like what you did. Something
> like:
> 
> ----
> Most archs with HAVE_ARCH_CALLER_ADDR have pretty much the same
> definitions of CALLER_ADDRx(n). Instead of duplicating the code for all
> the archs, define a ftrace_return_address0() and
> ftrace_return_address(n) that can be overwritten by the archs if they
> need to do something different. Instead of 7 macros in every arch, we
> now only have at most 2 (and actually only 1 as
> ftrace_return_address0() should be the same for all archs).
> 
> The CALLER_ADDRx(n) will now be defined in linux/ftrace.h and use the
> ftrace_return_address*(n?) macros. This removes a lot of the duplicate
> code.
> -----
> 
> Use that if you want :-)

Akashi: did you get around to posting a new version of this patch? We can't
take your arm64 patches until you get the core stuff merged...

Will
