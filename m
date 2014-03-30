Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaC3CrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 22:47:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaC3CrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 22:47:04 -0400
Date: Sun, 30 Mar 2014 04:47:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 08/29] ktap: add bytecode
 reader(kernel/trace/ktap/kp_bcread.[c|h])
Message-ID: <20140330024701.GA22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396017924-7754-9-git-send-email-jovi.zhangwei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396017924-7754-9-git-send-email-jovi.zhangwei@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Read debug info of a prototype. */
> +static void bcread_dbg(BCReadCtx *ctx, ktap_proto_t *pt, int sizedbg)
> +{
> +	void *lineinfo = (void *)proto_lineinfo(pt);
> +
> +	bcread_block(ctx, lineinfo, sizedbg);
> +	/* Swap lineinfo if the endianess differs. */


Why does this care about endianness? Can't that be handled in the user
space? And why would the user space create different endianness than
the host is?

> +	for (i = 0; i < sizekgc; i++, kr++) {
> +		int tp = bcread_uint32(ctx);
> +		if (tp >= BCDUMP_KGC_STR) {

The signedness handling all over this file is a scary.
What happens if the user puts in negative values or near overflow
values.

Most likely a lot of these checks should be unsigned
and need to be audited again (and ideally fuzzed too)

> +
> +	/* Allocate prototype object and initialize its fields. */
> +	pt = (ktap_proto_t *)kp_obj_new(ctx->ks, (int)sizept);

Error check?

Lots of other similar cases.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
