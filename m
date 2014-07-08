Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaGHVus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:50:48 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55915 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaGHVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140708.141708.2064358397103630362.davem@davemloft.net>
References: <f98ccbfee35a7ab7f9499ede9b34e6b1120d88f1.1404172155.git.decot@googlers.com>
 <20140707.193505.345276817146527821.davem@davemloft.net> <CAG88wWZ9GiqoOscqG4-ePOWo8bXgSTAQ6=6-tZPahMcxOvQMLg@mail.gmail.com>
 <20140708.141708.2064358397103630362.davem@davemloft.net>
From: David Decotigny <decot@googlers.com>
Date: Tue, 8 Jul 2014 14:50:24 -0700
Message-ID: <CAG88wWa9WTz4gwLHWAys1e96eWBgD+mcVW=hPh7a+b2ooJzBeQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/2] netpoll: avoid reference leaks
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>, amwang@redhat.com,
        antonio@meshcoding.com, Jiri Pirko <jpirko@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In that case, that's what the original code does: dropping this patch 2/2.

Patch 1/2 "netpoll: fix use after free" is still needed to prevent
panics, though.

On Tue, Jul 8, 2014 at 2:17 PM, David Miller <davem@davemloft.net> wrote:
> From: David Decotigny <decot@googlers.com>
> Date: Tue, 8 Jul 2014 12:35:14 -0700
>
>> Thanks for the feedback. This patch results from manual inspection of
>> the code. I agree my commit description is abusive: in the case of
>> bonding, I think everything is fine, there should be no ref leak,
>> cleanup paths seem clean.
>>
>> My point was to make things more predictable: ndo_netpoll_cleanup
>> called anyways to acknowledge actual loss of a ref to npinfo,
>> irrespective of whether it's the last ref or not. Without this patch,
>> calling ndo_netpoll_cleanup would depend on some timing behavior, hard
>> to predict, and users of the API have better be careful to reclaim the
>> refs manually anyways: as a consequence, not sure this callback is
>> actually required in its current inception.
>
> You've increased my confusion rather than decreased it.
>
> You fail to address the core issue in my feedback:
>
>         Whoever drops the refcount to zero must be the one to invoke
>         the cleanup function.
>
> Please address this concisely, and directly.
