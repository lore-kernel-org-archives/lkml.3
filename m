Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbaDBMgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:36:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:49103 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758289AbaDBMgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:36:06 -0400
Date: Wed, 2 Apr 2014 08:36:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: Introduce MODULE_STATE_COMING_FINAL to avoid
 ftrace warning
Message-ID: <20140402083603.051d08b0@gandalf.local.home>
In-Reply-To: <1396425266-3128-1-git-send-email-indou.takao@jp.fujitsu.com>
References: <1396425266-3128-1-git-send-email-indou.takao@jp.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Apr 2014 16:54:26 +0900
Takao Indoh <indou.takao@jp.fujitsu.com> wrote:

> This patch adds new module state MODULE_STATE_COMING_FINAL to avoid
> ftrace waring message when loading two modules simultaneously.
> 
> The original patch was written by Steven Rostedt, see below.
> https://lkml.org/lkml/2014/3/24/242
> 


> 
> This patch introduces MODULE_STATE_COMING_FINAL which means that the
> module is ready to be changed to ReadOnly. By this, the modules B is not
> change to RO at (2) because its state is still MODULE_STATE_COMING, so
> this warning message is avoided. Module B is changed to RO in the
> do_init_module() after comes back from notifier.
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>

As I'm the original author, add my:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

too.

-- Steve
