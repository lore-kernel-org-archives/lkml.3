Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab3BHGhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:37:06 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:36202 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3BHGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:37:05 -0500
MIME-Version: 1.0
In-Reply-To: <51148C93.6020204@250bpm.com>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
 <5113FCA7.4020207@mit.edu> <51140A60.4070705@250bpm.com> <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com>
 <51148C93.6020204@250bpm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 7 Feb 2013 22:36:43 -0800
Message-ID: <CALCETrVjRg95+xDnsg0L6JMYeFjFTr3HST9Mmi9utxrF1PggNQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
To: Martin Sustrik <sustrik@250bpm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 9:26 PM, Martin Sustrik <sustrik@250bpm.com> wrote:
> Hi Andy,
>
>
> On 08/02/13 02:03, Andy Lutomirski wrote:
>>
>> There may be some
>> advantage to adding (later on, if needed) an option to change the
>> flags set in:
>>
>> +               if (waitqueue_active(&ctx->wqh))
>> +                       wake_up_locked_poll(&ctx->wqh,
>> +                               (unsigned long)ctx->mask.events);
>>
>> (i.e. to allow the second parameter to omit some bits that were
>> already signaled.)  Allowing write to write a bigger struct in the
>> future won't break anything.
>
>
> I think I don't follow. Either the second parameter is supposed to be
> *newly* signaled events, in which case the events that were already signaled
> in the past should be ommitted, or it is meant to be *all* signaled events,
> in which case the current implementation is OK.

I defer to the experts here.  But I suspect that if you want to
perfectly emulate sockets, you may need to vary what you specify.
(IIRC tcp sockets report an EPOLLIN edge every time data is received
even if the receive buffer wasn't empty.)

--Andy
