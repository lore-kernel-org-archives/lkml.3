Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3LECSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:18:34 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64352 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3LECSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:18:33 -0500
Message-ID: <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: lots of brief rcu stalls.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 04 Dec 2013 18:18:30 -0800
In-Reply-To: <20131205001614.GI15492@linux.vnet.ibm.com>
References: <20131204232838.GA25592@redhat.com>
	 <20131205001614.GI15492@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-04 at 16:16 -0800, Paul E. McKenney wrote:
> +	if (rdp->rsp == rcu_state &&
> +	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
> +		rdp->rsp->jiffies_resched += 5;
> +		resched_cpu(rdp->cpu);
> +	}
> +
>  	return 0;
>  }

jiffies should not need ACCESS_ONCE(), right ?

It is one of the few variables marked with volatile keyword.



