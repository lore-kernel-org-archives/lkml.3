Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaIBQpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:45:06 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:11506 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbaIBQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:45:00 -0400
Message-ID: <5405F409.70107@c-s.fr>
Date: Tue, 02 Sep 2014 18:44:57 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: 3.16/3.16.1: Kernel Oops in nft_do_chain
References: <54059883.4060309@c-s.fr> <20140902104114.GA10805@salvia>
In-Reply-To: <20140902104114.GA10805@salvia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 02/09/2014 12:41, Pablo Neira Ayuso a écrit :
> On Tue, Sep 02, 2014 at 12:14:27PM +0200, leroy christophe wrote:
>> Calling 'iptables-compat -L', first time nothing is listed on the screen.
>> Second try, it generates following Oops.
> I'm going to pass this patch to -stable asap:
>
> commit b88825de8545ad252c31543fef13cadf4de7a2bc
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Aug 5 17:25:59 2014 +0200
>
>      netfilter: nf_tables: don't update chain with unset counters
>      
>      Fix possible replacement of the per-cpu chain counters by null
>      pointer when updating an existing chain in the commit path.
>      
>      Reported-by: Matteo Croce <technoboy85@gmail.com>
>      Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
> I think it's the root cause for this problem.
Thanks, it does fix the Oops I had.

Christophe

