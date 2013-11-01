Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3KAPJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3KAPJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:09:51 -0400
Date: Fri, 1 Nov 2013 16:09:10 +0100
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
Message-ID: <20131101150910.GA18278@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <1383029621-7384-11-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383029621-7384-11-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

Sorry if this was already discussed. But I can't really understand
the idea of this per-cpu buffer...

On 10/29, Namhyung Kim wrote:
>
> Fetching from user space should be done in a non-atomic context.  So
> use a per-cpu buffer and copy its content to the ring buffer
> atomically.  Note that we can migrate during accessing user memory
> thus use a per-cpu mutex to protect concurrent accesses.

And if the task migrates or just sleeps in page fault, another task
which hits another uprobe on the same CPU should wait.

Why we can't simply add trace_uprobe->buffer instead? Only to save
some memory? But every uprobe is very expensive in this sense anyway.

Oleg.

