Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbbAKViY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:38:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbAKViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:38:20 -0500
Message-ID: <54B2ED45.7070001@redhat.com>
Date: Sun, 11 Jan 2015 22:38:13 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christoph Jaeger <cj@linux.com>
CC: davem@davemloft.net, willemb@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header creation
 fails
References: <1420999276-28225-1-git-send-email-cj@linux.com>
In-Reply-To: <1420999276-28225-1-git-send-email-cj@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 07:01 PM, Christoph Jaeger wrote:
> Due to a misplaced parenthesis, the expression
>
>    (unlikely(offset) < 0),
>
> which expands to
>
>    (__builtin_expect(!!(offset), 0) < 0),
>
> never evaluates to true. Therefore, when sending packets with
> PF_PACKET/SOCK_DGRAM, packet_snd() does not abort as intended
> if the creation of the layer 2 header fails.
>
> Spotted by Coverity - CID 1259975 ("Operands don't affect result").
>
> Fixes: 9c7077622dd9 ("packet: make packet_snd fail on len smaller than l2 header")
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Thanks, Christoph!

Acked-by: Daniel Borkmann <dborkman@redhat.com>
