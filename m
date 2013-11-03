Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3KCUTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 15:19:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab3KCUTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:19:21 -0500
Date: Sun, 3 Nov 2013 21:20:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a
	ring buffer
Message-ID: <20131103202037.GA2785@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-11-git-send-email-namhyung@kernel.org> <20131101150910.GA18278@redhat.com> <20131101152232.GA2703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101152232.GA2703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, Oleg Nesterov wrote:
>
> Ah, please ignore... handler_chain() is not self-serialized, so
> tu->buffer needs locking/waiting too.

Still I have to admit that I strongly dislike this yet another
(and imho strange) memory pool. However, I am not going to argue
because I can't suggest something better right now.

But. Perhaps it makes sense to at least add a couple of trivial
helpers in 10/13? Something like arg_buf_get/put/init, just to
simplify the potential changes.

Also. I think we should not use this pool unconditionally but
again, this is another improvement we can do later.

Oleg.

