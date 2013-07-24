Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3GXCcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:32:11 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49099 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3GXCcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGtLavwdPdq_Qojz_x-DQ3KXfZp0vPYr6imKtNxN0Hf_2Q@mail.gmail.com>
References: <1374518841.4990.26.camel@edumazet-glaptop>
	<1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
	<1374559827.4990.143.camel@edumazet-glaptop>
	<20130723.164656.1794159338719943519.davem@davemloft.net>
	<CANEJEGtLavwdPdq_Qojz_x-DQ3KXfZp0vPYr6imKtNxN0Hf_2Q@mail.gmail.com>
Date: Tue, 23 Jul 2013 19:32:08 -0700
Message-ID: <CANEJEGv9G0SSUQOPqbqb_Fpcth7Qz2nkT_zOUQG=U2FH=g1_XA@mail.gmail.com>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Grant Grundler <grundler@google.com>
To: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>, oliver@neukum.org,
        Freddy Xin <freddy@asix.com.tw>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QVNJWCBMb3VpcyBb6JiH5aiB6Zm4XQ==?= <louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 7:29 PM, Grant Grundler <grundler@google.com> wrote:
> On Tue, Jul 23, 2013 at 4:46 PM, David Miller <davem@davemloft.net> wrote:
> ...
>> A quick scan shows that smsc75xx, smsc95xx, and ax88179_178a all have
>> this problem.
>>
>> Instead of the patch starting this thread, I'd like to see one that
>> hits all three drivers and removes all SG and TSO features bits from
>> both the ->features _and_ ->hw_features settings.
>
> Since you are asking to remove TSO, do you also want skb_linearize()
> calls in ax88179_178a.c and smsc75xx.c removed as well?

Nevermind...Eric already removed skb_linearize calls in his patch.

cheers,
grant

>
> Not part of the original patch - but based on this thread, Eric seems
> to think calling skb_linearize isn't necessary or helpful either.
>
> cheers,
> grant
