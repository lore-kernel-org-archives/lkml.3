Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3KLSnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:43:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3KLSnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:43:01 -0500
Date: Tue, 12 Nov 2013 19:44:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131112184412.GA2492@redhat.com>
References: <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com> <20131106173754.GA11299@redhat.com> <87a9hgwqal.fsf@sejong.aot.lge.com> <527DA997.4080306@hitachi.com> <20131109152313.GA14630@redhat.com> <87siv2uk1q.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siv2uk1q.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 11/12, Namhyung Kim wrote:
>
> Let me clarify what I understand.
>
> For @addr syntax: kernel does no translation and uses given address

Yes,

> For @+addr syntax: user-space uses relative symbol address from a loaded
>                    base address and kernel calculates the base address
>                    using "current->utask->vaddr - tu->offset".

Looks right to me.

IOW, when user-space calculates the "addr" for @+ argument, it should
assume that this binary will be mmaped at "NULL" (so that the virtual
address of the probed function is always equal to its offset in the
probed binary).

Masami, Steven, et al, do you agree?

Oleg.

