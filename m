Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaFDQXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:23:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37560 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530AbaFDQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:23:53 -0400
Date: Wed, 4 Jun 2014 12:23:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [V4 PATCH ftrace/core] ftrace: Introduce saved_cmdlines_size
 file
Message-ID: <20140604122350.5223264b@gandalf.local.home>
In-Reply-To: <20140604071848.29340.82132.stgit@yunodevel>
References: <538E8F38.2070706@hitachi.com>
	<20140604071848.29340.82132.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Almost there ;-)

On Wed, 04 Jun 2014 16:18:48 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> +
> +static int allocate_cmdlines_buffer(unsigned int val,
> +				    struct saved_cmdlines_buffer *s)
> +{
> +	s->map_cmdline_to_pid = kmalloc(val * sizeof(unsigned), GFP_KERNEL);

s/sizeof(unsigned)/sizeof(*s->map_cmdline_to_pid)/

For the same reason as the memset.

Other than that, I think the rest looks good.

-- Steve

> +	if (!s->map_cmdline_to_pid)
> +		return -ENOMEM;
> +
> +	s->saved_cmdlines = kmalloc(val * TASK_COMM_LEN, GFP_KERNEL);
> +	if (!s->saved_cmdlines) {
> +		kfree(s->map_cmdline_to_pid);
> +		return -ENOMEM;
> +	}
> +
> +	s->cmdline_idx = 0;
> +	s->cmdline_num = val;
> +	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
> +	       sizeof(s->map_pid_to_cmdline));
> +	memset(s->map_cmdline_to_pid, NO_CMDLINE_MAP,
> +	       val * sizeof(*s->map_cmdline_to_pid));
> +
> +	return 0;
> +}
> +
