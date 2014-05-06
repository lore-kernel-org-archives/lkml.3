Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaEFDKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:10:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:10:16 -0400
Date: Mon, 05 May 2014 23:10:15 -0400 (EDT)
Message-Id: <20140505.231015.1267261274092331777.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 10/24] net, diet: Make LPF filter optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-11-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-11-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:10:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:25:59 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> Small systems don't need the LPF filter, so make it all
> optional
> 
> Saves about 4K text
> 
>    text	   data	    bss	    dec	    hex	filename
>  483545	  19371	  13480	 516396	  7e12c	net/built-in.o-wo-filter
>  487675	  19275	  13480	 520430	  7f0ee	net/built-in.o-with-filter
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I think you highly underestimate how much "small systems" use
packet capturing and thus BPF.
