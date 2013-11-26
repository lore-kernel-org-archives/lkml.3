Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3KZRtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:49:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3KZRtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:49:32 -0500
Date: Tue, 26 Nov 2013 18:50:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: modules, add_kallsyms() && DEFINE_PER_CPU
Message-ID: <20131126175037.GE14028@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <20131126174446.GD14028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126174446.GD14028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Oleg Nesterov wrote:
>
> Note: this doesn't work for modules, but module's per-cpu data is
> not visible for kallsyms_lookup_name() anyway.

Rusty, I am just curious if it makes sense to change this or not...

But DEFINE_PER_CPU'ed symbols are ignored by add_kallsyms(). I guess
this is because is_core_symbol() requires "sh_flags & SHF_ALLOC".
And probably because of INIT_OFFSET_MASK.

Oleg.

