Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3H3QgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:36:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52813 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3H3QgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:36:08 -0400
Message-ID: <5220C9C6.5020808@zytor.com>
Date: Fri, 30 Aug 2013 09:35:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled DYNAMIC_FTRACE
References: <5217908E.2040702@siemens.com> <5220BC1A.3030108@zytor.com> <20130830115142.1ee4c825@gandalf.local.home>
In-Reply-To: <20130830115142.1ee4c825@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 08:51 AM, Steven Rostedt wrote:
> 
> It does when dynamic tracing is enabled. But this issue is with static
> tracing, there's no code modification, thus all functions call
> mcount/__fentry__ and we need to look at a variable to determine if we
> should trace or not.
> 

And of course global variables are a no-no without special handling in
pre-paging mode.  Sigh.

You *could* bail out of the calling address is < PAGE_OFFSET.

	-hpa

