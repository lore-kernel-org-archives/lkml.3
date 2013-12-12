Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3LLKpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:45:16 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:50380 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3LLKpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:45:14 -0500
Message-ID: <52A98DBF.4090702@appelbaum.net>
Date: Thu, 12 Dec 2013 10:19:43 +0000
From: Jacob Appelbaum <jacob@appelbaum.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christian Grothoff <grothoff@in.tum.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, knock@gnunet.org
Subject: Re: [PATCH] TCP: add option for silent port knocking with integrity
 protection
References: <52A75EF8.3010308@in.tum.de> <20131211.150137.368953964178408437.davem@davemloft.net> <52A8C8B4.4060109@in.tum.de> <20131211122637.75b09074@nehalam.linuxnetplumber.net> <87bo0nulkt.fsf@tassilo.jf.intel.com> <52A8ECF5.3070604@in.tum.de> <20131212012317.GL21717@two.firstfloor.org>
In-Reply-To: <20131212012317.GL21717@two.firstfloor.org>
OpenPGP: id=4193A197
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen:
>> ... and then do the same for the first TCP packet with payload? And you
> 
> That gets passed through by the firewall rule.
> 
As an application developer, I find it very common for our users to have
difficulty synchronizing userspace program needs and firewall rules.
This option would greatly enable hiding of Tor bridges and other
services where mere presence on the network is in itself a vulnerability.

>> seriously would consider that "safer" or "less error prone", starting
> 
> Yes the risk of adding exploitable holes to the kernel is signficantly
> lower.

In the case of a Tor bridge, when people are able to scan the entire
internet, as they are, they find Tor bridges and then add those bridges
to a database or to various national firewalls.

Increasing scanning resistance improves the security of such bridges -
though a passive (eg: sniffing) adversary may still discover such a
bridge for blocking, this kernel modification has a second benefit - it
will prevent most exploitable conditions from having an avenue of
attack. Such an attacker, even if they know the IP of a bridge will need
to find a way to break TLS or any of our other transport layer security
protocol that we're using.

I think that generally, I would prefer if the code didn't use MD5 but
otherwise, I don't see any real disk of adding an exploitable hole. It
seems silly to disable it by default though - ideally, I'd like a sysctl
to ensure that Tor could use this without making the user recompile
their kernel. That is more of a pain than running a userspace helper, I
think.

All the best,
Jacob
