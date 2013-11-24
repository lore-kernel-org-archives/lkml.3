Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3KXHc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 02:32:58 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36955 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3KXHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 02:32:56 -0500
Message-ID: <5291ABA5.7030505@hitachi.com>
Date: Sun, 24 Nov 2013 16:32:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: Introduce "pseudo registers" for FETCH_MTD_reg
References: <20131123201543.GA22148@redhat.com> <20131123201605.GB22148@redhat.com>
In-Reply-To: <20131123201605.GB22148@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/24 5:16), Oleg Nesterov wrote:
> The probe can dump the registers or memory, but it is not possible
> to dump, say, current->pid. This patch adds the pseudo regs table,
> currently it has only two methods to get current/smp_processor_id
> but it can be trivially extended.

Good catch! :)

> This syntax is %%pseudo-reg-name, I agree in advance with any other
> naming.

For this kind of use, kprobe-tracer already provides '$' prefix :)
e.g. $stack, $retval etc. Please see parse_probe_vars in trace_probe.c.

So, $current and $cpu is better for me.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


