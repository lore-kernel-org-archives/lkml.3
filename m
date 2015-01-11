Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbbAKStf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:49:35 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:51384 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAKStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:49:32 -0500
MIME-Version: 1.0
In-Reply-To: <1421001331.5947.101.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1420999276-28225-1-git-send-email-cj@linux.com> <1421001331.5947.101.camel@edumazet-glaptop2.roam.corp.google.com>
From: Willem de Bruijn <willemb@google.com>
Date: Sun, 11 Jan 2015 13:49:01 -0500
Message-ID: <CA+FuTSe2uob_2VBzqGCcNtmTMTUg5rBfi1E_+jUvOHtjDUkGpg@mail.gmail.com>
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header
 creation fails
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Jaeger <cj@linux.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 1:35 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Sun, 2015-01-11 at 13:01 -0500, Christoph Jaeger wrote:
>> Due to a misplaced parenthesis, the expression
>>
>>   (unlikely(offset) < 0),
>>
>> which expands to
>>
>>   (__builtin_expect(!!(offset), 0) < 0),
>>
>> never evaluates to true. Therefore, when sending packets with
>> PF_PACKET/SOCK_DGRAM, packet_snd() does not abort as intended
>> if the creation of the layer 2 header fails.
>>
>> Spotted by Coverity - CID 1259975 ("Operands don't affect result").
>>
>> Fixes: 9c7077622dd9 ("packet: make packet_snd fail on len smaller than l2 header")
>> Signed-off-by: Christoph Jaeger <cj@linux.com>
>> ---
>
> Nice catch !
>
> Acked-by: Eric Dumazet <edumazet@google.com>
>

Indeed. I'm responsible for that typo. Thanks a lot for catching it!

Acked-by: Willem de Bruijn <willemb@google.com>
