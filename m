Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaJCSj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:39:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34277 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaJCSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:39:24 -0400
Message-ID: <542EED58.7030707@kernel.dk>
Date: Fri, 03 Oct 2014 12:39:20 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, Benjamin LaHaise <bcrl@kvack.org>
CC: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Jeff Moyer <jmoyer@redhat.com>, Slava Pestov <sp@daterainc.com>
Subject: Re: [PATCH] aio: Fix return code of io_submit() (RFC)
References: <1412359693-2535-1-git-send-email-kmo@daterainc.com> <542EE753.20005@kernel.dk> <20141003182220.GA17057@kvack.org> <20141003183147.GE17903@daterainc.com>
In-Reply-To: <20141003183147.GE17903@daterainc.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-03 12:31, Kent Overstreet wrote:
> On Fri, Oct 03, 2014 at 02:22:20PM -0400, Benjamin LaHaise wrote:
>> On Fri, Oct 03, 2014 at 12:13:39PM -0600, Jens Axboe wrote:
>>> How are applications supposed to deal with ENOMEM? I think the answer
>>> here is that they can't, it would be a fatal condition. AIO must provide
>>> isn't own guarantee of progress, with a mempool or similar.
>>
>> I'm not sure if using a mempool is appropriate for allocations that are
>> driven by userland code.  At least with an ENOMEM error, an application
>> could free up some of the memory it allocated and possibly recover the
>> system.
>
> I guess it's going to depend on the application... some applications really want
> to always make forward progress (much like a lot of code in the kernel), so
> they're going to want the mempool semantics and we in the kernel are in a much
> better position to implement that correctly (think of all the applications that
> are just going to sleep and retry on -ENOMEM).

Precisely, there's no real way to do that in the application. Especially 
if it has no pending IO it can just wait on, it'll be a sleep and retry 
thing

> we kind of want another flag in the syscall args that's the moral equivalent of
> MSG_DONTWAIT but for memory allocations; it'd translate into "mempool +
> GFP_KERNEL, or GFP_NOWAIT".

We do...

> not that I'm actually going to implement that :)

It's worth keeping in mind for if we do extend the API for some reason.

-- 
Jens Axboe

