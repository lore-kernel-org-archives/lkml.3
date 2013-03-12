Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3CLPy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:54:57 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:40044 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754947Ab3CLPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:54:56 -0400
Message-ID: <513F4FCE.5090109@mimc.co.uk>
Date: Tue, 12 Mar 2013 15:54:54 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Excessive ethernet interrupts on AM335x board
References: <513F4B58.1000204@mimc.co.uk>
In-Reply-To: <513F4B58.1000204@mimc.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/13 15:35, Mark Jackson wrote:
> I'm just fighting an issue with ethernet on our custom AM335x board:-
> 
> # uname -a
> Linux nanobone 3.9.0-rc2-00113-gd60f039 #139 Tue Mar 12 15:14:01 GMT 2013 armv7l GNU/Linux
> 
> Every now and then, the whole unit slows to a crawl.  The only indication of any problem is:-
> 
> (a) the serial tty port becomes much less responsive
> (b) normal ping times jump from 1ms to >10sec (sometimes >20sec !!)
> (c) the ethernet interrupt count rockets (see below)
> 
> I've tried to force the problem by flood pinging from my PC.
> 
> # while true
>> do grep "58:" /proc/interrupts; sleep 10
>> done
>  58:       1291      INTC  4a100000.ethernet  <<< normal pinging (about 100 irqs per 10sec)
>  58:       1333      INTC  4a100000.ethernet
>  58:       1372      INTC  4a100000.ethernet
>  58:       3979      INTC  4a100000.ethernet  <<< start flood ping (about 4k irqs per 10sec)
>  58:       6540      INTC  4a100000.ethernet
>  58:      17519      INTC  4a100000.ethernet  <<< big jump >>>
>  58:      20169      INTC  4a100000.ethernet
>  58:      22775      INTC  4a100000.ethernet
>  58:      25368      INTC  4a100000.ethernet
>  58:      34598      INTC  4a100000.ethernet  <<< big jump >>>
>  58:      37182      INTC  4a100000.ethernet
>  58:      39730      INTC  4a100000.ethernet
>  58:     141220      INTC  4a100000.ethernet  <<< whoa !!! >>>
>  58:     146080      INTC  4a100000.ethernet

Doing the flood ping test on an old Beaglebone (running kernel 3.2.34 on an sdcard), I get:-

# while true
> do grep "94:" /proc/interrupts; sleep 10
ne
> done
 94:     281353      INTC  cpsw.0
 94:     370782      INTC  cpsw.0
 94:     457537      INTC  cpsw.0
 94:     544876      INTC  cpsw.0
 94:     631795      INTC  cpsw.0
 94:     717747      INTC  cpsw.0
 94:     805974      INTC  cpsw.0
 94:     892961      INTC  cpsw.0
 94:     981490      INTC  cpsw.0
 94:    1070627      INTC  cpsw.0
 94:    1153086      INTC  cpsw.0
 94:    1242060      INTC  cpsw.0
 94:    1327734      INTC  cpsw.0
 94:    1413705      INTC  cpsw.0
 94:    1504494      INTC  cpsw.0
 94:    1591395      INTC  cpsw.0
 94:    1676769      INTC  cpsw.0

So these are going up by 90k irqs per 10sec ... meaning that the AM335x
board seems to be *dropping* most of its ethernet irqs.

I'll try to get 3.9.0-rc2 on the BB and retest.

Mark J.
