Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3CLPfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:35:55 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:39900 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755197Ab3CLPfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:35:54 -0400
Message-ID: <513F4B58.1000204@mimc.co.uk>
Date: Tue, 12 Mar 2013 15:35:52 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Excessive ethernet interrupts on AM335x board
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just fighting an issue with ethernet on our custom AM335x board:-

# uname -a
Linux nanobone 3.9.0-rc2-00113-gd60f039 #139 Tue Mar 12 15:14:01 GMT 2013 armv7l GNU/Linux

Every now and then, the whole unit slows to a crawl.  The only indication of any problem is:-

(a) the serial tty port becomes much less responsive
(b) normal ping times jump from 1ms to >10sec (sometimes >20sec !!)
(c) the ethernet interrupt count rockets (see below)

I've tried to force the problem by flood pinging from my PC.

# while true
> do grep "58:" /proc/interrupts; sleep 10
> done
 58:       1291      INTC  4a100000.ethernet  <<< normal pinging (about 100 irqs per 10sec)
 58:       1333      INTC  4a100000.ethernet
 58:       1372      INTC  4a100000.ethernet
 58:       3979      INTC  4a100000.ethernet  <<< start flood ping (about 4k irqs per 10sec)
 58:       6540      INTC  4a100000.ethernet
 58:      17519      INTC  4a100000.ethernet  <<< big jump >>>
 58:      20169      INTC  4a100000.ethernet
 58:      22775      INTC  4a100000.ethernet
 58:      25368      INTC  4a100000.ethernet
 58:      34598      INTC  4a100000.ethernet  <<< big jump >>>
 58:      37182      INTC  4a100000.ethernet
 58:      39730      INTC  4a100000.ethernet
 58:     141220      INTC  4a100000.ethernet  <<< whoa !!! >>>
 58:     146080      INTC  4a100000.ethernet
 58:     149351      INTC  4a100000.ethernet
 58:     152922      INTC  4a100000.ethernet
 58:     156420      INTC  4a100000.ethernet
 58:     159538      INTC  4a100000.ethernet
 58:     162711      INTC  4a100000.ethernet
 58:     165746      INTC  4a100000.ethernet
 58:     168973      INTC  4a100000.ethernet
 58:     172128      INTC  4a100000.ethernet
 58:     175030      INTC  4a100000.ethernet
 58:     177957      INTC  4a100000.ethernet
 58:     180782      INTC  4a100000.ethernet
 58:     183618      INTC  4a100000.ethernet
 58:     186450      INTC  4a100000.ethernet
 58:     189242      INTC  4a100000.ethernet
 58:     191909      INTC  4a100000.ethernet
 58:     194565      INTC  4a100000.ethernet
 58:     197153      INTC  4a100000.ethernet
 58:     199730      INTC  4a100000.ethernet  <<< another big jump >>>
 58:     252629      INTC  4a100000.ethernet
 58:     262955      INTC  4a100000.ethernet
 58:     265557      INTC  4a100000.ethernet
 58:     268131      INTC  4a100000.ethernet
 58:     272586      INTC  4a100000.ethernet
 58:     275623      INTC  4a100000.ethernet  <<< here I stop flood pings >>>
[  631.727758] nfs: server 10.0.0.100 not responding, still trying
[  638.738864] nfs: server 10.0.0.100 OK
 58:     277694      INTC  4a100000.ethernet
 58:     277703      INTC  4a100000.ethernet
 58:     277709      INTC  4a100000.ethernet
 58:     277719      INTC  4a100000.ethernet
 58:     277725      INTC  4a100000.ethernet
 58:     277734      INTC  4a100000.ethernet
 58:     277745      INTC  4a100000.ethernet

As you can see, when I stop the flood pings, the nfs link is now reported
as being lost.

Any ideas ?

Cheers
Mark J.
