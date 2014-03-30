Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaC3IIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 04:08:45 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:33982 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaC3IIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 04:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140330024701.GA22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-9-git-send-email-jovi.zhangwei@gmail.com>
	<20140330024701.GA22728@two.firstfloor.org>
Date: Sun, 30 Mar 2014 16:02:49 +0800
Message-ID: <CAGdX0WG6Nid66iuRWqLbfmH89XacEXuUNYCNjnB7j=HYiyCKBw@mail.gmail.com>
Subject: Re: [PATCH v2 08/29] ktap: add bytecode reader(kernel/trace/ktap/kp_bcread.[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 10:47 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> +/* Read debug info of a prototype. */
>> +static void bcread_dbg(BCReadCtx *ctx, ktap_proto_t *pt, int sizedbg)
>> +{
>> +     void *lineinfo = (void *)proto_lineinfo(pt);
>> +
>> +     bcread_block(ctx, lineinfo, sizedbg);
>> +     /* Swap lineinfo if the endianess differs. */
>
>
> Why does this care about endianness? Can't that be handled in the user
> space? And why would the user space create different endianness than
> the host is?
>
That's designed for portability initially, it means we can just run bytecode
without compile script file everywhere, especially when compilation  is
a heavily task for some embedded platform, even though ktap compilation
is extremely fast.

I doubt maybe there will have this bytecode portability requirement in future?

>> +     for (i = 0; i < sizekgc; i++, kr++) {
>> +             int tp = bcread_uint32(ctx);
>> +             if (tp >= BCDUMP_KGC_STR) {
>
> The signedness handling all over this file is a scary.
> What happens if the user puts in negative values or near overflow
> values.
>
> Most likely a lot of these checks should be unsigned
> and need to be audited again (and ideally fuzzed too)
>
>> +
>> +     /* Allocate prototype object and initialize its fields. */
>> +     pt = (ktap_proto_t *)kp_obj_new(ctx->ks, (int)sizept);
>
> Error check?
>
> Lots of other similar cases.
>
I will take more check in kp_bcread.c file, will fix in next version.

Thanks.

Jovi
