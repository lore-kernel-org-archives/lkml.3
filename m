Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaHBKde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 06:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaHBKdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 06:33:33 -0400
Message-ID: <53DCBE49.5040507@redhat.com>
Date: Sat, 02 Aug 2014 12:32:41 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] lib: Resizable, Scalable, Concurrent Hash
 Table
References: <cover.1406971567.git.tgraf@suug.ch> <f7740ef7d22a334a775348caee916f1ddb3c584d.1406971567.git.tgraf@suug.ch>
In-Reply-To: <f7740ef7d22a334a775348caee916f1ddb3c584d.1406971567.git.tgraf@suug.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 11:47 AM, Thomas Graf wrote:
> Generic implementation of a resizable, scalable, concurrent hash table
> based on [0]. The implementation supports both, fixed size keys specified
> via an offset and length, or arbitrary keys via own hash and compare
> functions.
> 
> Lookups are lockless and protected as RCU read side critical sections.
> Automatic growing/shrinking based on user configurable watermarks is
> available while allowing concurrent lookups to take place.
> 
> Objects to be hashed must include a struct rhash_head. The reason for not
> using the existing struct hlist_head is that the expansion and shrinking
> will have two buckets point to a single entry which would lead in obscure
> reverse chaining behaviour.
> 
> Code includes a boot selftest if CONFIG_TEST_RHASHTABLE is defined.
> 
> [0] https://www.usenix.org/legacy/event/atc11/tech/final_files/Triplett.pdf
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> ---
>  include/linux/rhashtable.h | 213 ++++++++++++
>  lib/Kconfig.debug          |   8 +
>  lib/Makefile               |   2 +-
>  lib/rhashtable.c           | 797 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1019 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/rhashtable.h
>  create mode 100644 lib/rhashtable.c
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@redhat.com>

