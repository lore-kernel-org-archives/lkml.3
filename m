Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaLBFIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:08:49 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33096 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaLBFIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:08:48 -0500
Message-ID: <1417496925.5303.18.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH V2 net-next] udp: Neaten and reduce size of
 compute_score functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 21:08:45 -0800
In-Reply-To: <1417494546.4894.12.camel@perches.com>
References: <1417484341.4894.6.camel@perches.com>
	 <1417489141.4442.24.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1417489760.4894.8.camel@perches.com>
	 <1417494546.4894.12.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 20:29 -0800, Joe Perches wrote:
> The compute_score functions are a bit difficult to read.
> 
> Neaten them a bit to reduce object sizes and make them a
> bit more intelligible.
> 
> Return early to avoid indentation and avoid unnecessary
> initializations.
> 
> (allyesconfig, but w/ -O2 and no profiling)

hmm... Not sure how you get such large numbers...


> 
> $ size net/ipv[46]/udp.o.*
>    text    data     bss     dec     hex filename
>   28680    1184      25   29889    74c1 net/ipv4/udp.o.new
>   28756    1184      25   29965    750d net/ipv4/udp.o.old
>   17600    1010       2   18612    48b4 net/ipv6/udp.o.new
>   17632    1010       2   18644    48d4 net/ipv6/udp.o.old

Here I have :

# size net/ipv4/udp.o.*
   text	   data	    bss	    dec	    hex	filename
  21989	    616	      9	  22614	   5856	net/ipv4/udp.o.old
  21957	    616	      9	  22582	   5836	net/ipv4/udp.o.new


With CONFIG_CC_OPTIMIZE_FOR_SIZE=y I even have an opposite result (code
gets bigger after your patch)

# size net/ipv4/udp.o.*
   text	   data	    bss	    dec	    hex	filename
  17242	    600	      9	  17851	   45bb	net/ipv4/udp.o.old
  17256	    600	      9	  17865	   45c9	net/ipv4/udp.o.new

Anyway, your patch looks fine to me, no matter what the code size is.

Acked-by: Eric Dumazet <edumazet@google.com>


