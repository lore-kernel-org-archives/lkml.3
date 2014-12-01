Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaLATO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbaLATO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:14:27 -0500
Message-ID: <547CBE0D.8010501@redhat.com>
Date: Mon, 01 Dec 2014 20:14:21 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
CC: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com
Subject: Re: panic in skb_push via sctp
References: <CAP145pgZ2rbALf-Ce=uGc72DBCNXBvkrEPG43VUkSqkpiLuKsA@mail.gmail.com> <547CA719.6060101@redhat.com> <CAP145pggcEUKz3QhDEGdzWZDusPfwJsZ8juqjbRr+8g6RxuJfA@mail.gmail.com> <547CAEA3.3090906@redhat.com> <CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com>
In-Reply-To: <CAP145pici-xNuvyhdyRdSok_p_1KXvuNKeceMcdaWdEw8VOBuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 08:00 PM, Robert Święcki wrote:
> 2014-12-01 19:08 GMT+01:00 Daniel Borkmann <dborkman@redhat.com>:
>>
>>> Thanks for looking into it. I can try with your patch, but no
>>> guarantees that the fuzzer will hit the same condition in some
>>> reasonable time-frame. Will get back in some time with results.
>>
>> Ok, thanks!
>>
>>> PS. If you think it's possible to create a repro (userland code) which
>>> can trigger this, I can give it a try.
>>
>> Did by accident trinity create tunnels? It looks that upper layer
>> protocols (except SCTP) all allocate and reserve MAX_HEADER to
>> accommodate enough head room in worst case for possible tunnels.
>
> Not sure, but I run it inside a pid/ipc/uts/etc/user-namespaces where
> it operates with a full set of capabilities, so most of the SOCK_RAW
> and tunnel-like-creating calls succeed, so maybe..

Ok thanks, can you post your .config?
