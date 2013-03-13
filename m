Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3CMKc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:32:26 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:45385 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3CMKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <513F4B58.1000204@mimc.co.uk>
References: <513F4B58.1000204@mimc.co.uk>
Date: Wed, 13 Mar 2013 11:32:22 +0100
Message-ID: <CACTFLAPv=OGaWaz+BdPxr56e56c=cx8QYuc9TUK61Bk4WD5=vg@mail.gmail.com>
Subject: Re: Excessive ethernet interrupts on AM335x board
From: Daniel Mack <zonque@gmail.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 4:35 PM, Mark Jackson <mpfj-list@mimc.co.uk> wrote:
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
>  58:     149351      INTC  4a100000.ethernet
>  58:     152922      INTC  4a100000.ethernet
>  58:     156420      INTC  4a100000.ethernet
>  58:     159538      INTC  4a100000.ethernet
>  58:     162711      INTC  4a100000.ethernet
>  58:     165746      INTC  4a100000.ethernet
>  58:     168973      INTC  4a100000.ethernet
>  58:     172128      INTC  4a100000.ethernet
>  58:     175030      INTC  4a100000.ethernet
>  58:     177957      INTC  4a100000.ethernet
>  58:     180782      INTC  4a100000.ethernet
>  58:     183618      INTC  4a100000.ethernet
>  58:     186450      INTC  4a100000.ethernet
>  58:     189242      INTC  4a100000.ethernet
>  58:     191909      INTC  4a100000.ethernet
>  58:     194565      INTC  4a100000.ethernet
>  58:     197153      INTC  4a100000.ethernet
>  58:     199730      INTC  4a100000.ethernet  <<< another big jump >>>
>  58:     252629      INTC  4a100000.ethernet
>  58:     262955      INTC  4a100000.ethernet
>  58:     265557      INTC  4a100000.ethernet
>  58:     268131      INTC  4a100000.ethernet
>  58:     272586      INTC  4a100000.ethernet
>  58:     275623      INTC  4a100000.ethernet  <<< here I stop flood pings >>>
> [  631.727758] nfs: server 10.0.0.100 not responding, still trying
> [  638.738864] nfs: server 10.0.0.100 OK
>  58:     277694      INTC  4a100000.ethernet
>  58:     277703      INTC  4a100000.ethernet
>  58:     277709      INTC  4a100000.ethernet
>  58:     277719      INTC  4a100000.ethernet
>  58:     277725      INTC  4a100000.ethernet
>  58:     277734      INTC  4a100000.ethernet
>  58:     277745      INTC  4a100000.ethernet
>
> As you can see, when I stop the flood pings, the nfs link is now reported
> as being lost.

I had the same problem. Please check this patch, I'm sure it will fix you issue:

  https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d35162f89b8f00537d7b240b76d2d0e8b8d29aa0



Daniel
