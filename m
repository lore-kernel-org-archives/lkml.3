Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbbAKSfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:35:36 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34763 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbAKSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:35:33 -0500
Message-ID: <1421001331.5947.101.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header
 creation fails
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Jaeger <cj@linux.com>
Cc: davem@davemloft.net, willemb@google.com, edumazet@google.com,
        dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2015 10:35:31 -0800
In-Reply-To: <1420999276-28225-1-git-send-email-cj@linux.com>
References: <1420999276-28225-1-git-send-email-cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 13:01 -0500, Christoph Jaeger wrote:
> Due to a misplaced parenthesis, the expression
> 
>   (unlikely(offset) < 0),
> 
> which expands to
> 
>   (__builtin_expect(!!(offset), 0) < 0),
> 
> never evaluates to true. Therefore, when sending packets with
> PF_PACKET/SOCK_DGRAM, packet_snd() does not abort as intended
> if the creation of the layer 2 header fails.
> 
> Spotted by Coverity - CID 1259975 ("Operands don't affect result").
> 
> Fixes: 9c7077622dd9 ("packet: make packet_snd fail on len smaller than l2 header")
> Signed-off-by: Christoph Jaeger <cj@linux.com>
> ---

Nice catch !

Acked-by: Eric Dumazet <edumazet@google.com>


