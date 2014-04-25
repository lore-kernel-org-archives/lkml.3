Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaDYQpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:45:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51173 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaDYQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:45:34 -0400
Date: Fri, 25 Apr 2014 12:45:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: Re: [RFC v3 1/9] sysrq: Implement __handle_sysrq_nolock to avoid
 recursive locking in kdb
Message-ID: <20140425124530.52fd696c@gandalf.local.home>
In-Reply-To: <1398443370-12668-2-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014 17:29:22 +0100
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> If kdb is triggered using SysRq-g then any use of the sr command results
> in the SysRq key table lock being recursively acquired, killing the debug
> session. That patch resolves the problem by introducing a _nolock
> alternative for __handle_sysrq.
> 
> Strictly speaking this approach risks racing on the key table when kdb is
> triggered by something other than SysRq-g however in that case any other
> CPU involved should release the spin lock before kgdb parks the slave
> CPUs.

Is that case documented somewhere in the code comments?

-- Steve
