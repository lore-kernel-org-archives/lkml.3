Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3EaXDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:03:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab3EaXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:03:01 -0400
Date: Fri, 31 May 2013 16:02:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] sys/reboot: boolize C_A_D
Message-Id: <20130531160259.553761ddeb6095d22e8cea0d@linux-foundation.org>
In-Reply-To: <1369900686-5936-3-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
	<1369900686-5936-3-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 15:58:05 +0800 liguang <lig.fnst@cn.fujitsu.com> wrote:

> --- a/include/linux/reboot.h
> +++ b/include/linux/reboot.h
> @@ -35,7 +35,7 @@ extern void kernel_restart(char *cmd);
>  extern void kernel_halt(void);
>  extern void kernel_power_off(void);
>  
> -extern int C_A_D; /* for sysctl */
> +extern bool C_A_D; /* for sysctl */
>  void ctrl_alt_del(void);

This means that the pointer in kernel/sysctl.c:kern_table.data now
points at a bool but is declared to have size sizeof(int).

That happens to work with current gcc verions, but there's no rule
which states that sizeof(bool) must equal sizeof(int).

And I'm not sure that changing kern_table to use sizeof(bool) is really
worth all the bother.
