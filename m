Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaD0Qw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:52:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaD0QwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:52:24 -0400
Date: Sun, 27 Apr 2014 18:52:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] uprobes/x86: cleanup "riprel" functions
Message-ID: <20140427165200.GA3956@redhat.com>
References: <20140417200228.GA31097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417200228.GA31097@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Oleg Nesterov wrote:
>
> On 04/17, Oleg Nesterov wrote:
> >
> > This series only fixes the problem. I'll send more changes to address
> > some of TODO's mentioned in the changelogs later.
>
> This is probably the last series I am sending in this thread, before the
> next PULL request. This completes the changes which I planned from the
> very beginning, except "emulate jczx/loopz" which I am still unsure about.

I lied, let me send another short series.

I was not going to do this now, I am a bit tired of uprobes ;) But it seems
that Denys has a very good idea, we can simplify rip-relative handling.

However, if we are are going to change this code, imho we need to cleanup it
first. handle_riprel_insn(), pre_xol_rip_insn() and handle_riprel_post_xol()
look really annoying, imho. Even the naming asks for the cleanup imo, despite
the fact that usually I ignore the naming completely.

Oleg.

 arch/x86/kernel/uprobes.c |   56 +++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

