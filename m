Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaJFTfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:35:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36227 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbaJFTfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:35:01 -0400
X-Sasl-enc: KK8bcwQyUD2EcXXICSreJOccuwM4uH8P7PwXu/ssdK+v 1412624100
Date: Mon, 6 Oct 2014 16:34:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
Message-ID: <20141006193448.GB8238@khazad-dum.debian.net>
References: <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
 <20141003120345.GA6652@localhost.localdomain>
 <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos>
 <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
 <alpine.DEB.2.11.1410060959510.4383@nanos>
 <alpine.DEB.2.11.1410060521010.27574@gentwo.org>
 <alpine.DEB.2.11.1410061449290.4383@nanos>
 <alpine.DEB.2.11.1410061014080.29937@gentwo.org>
 <alpine.DEB.2.11.1410061726510.4383@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410061726510.4383@nanos>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Tools expect the number of interrupt to increase linearly and not jump by
> > 2^32 once in awhile. There are functions in the kernel (/proc/stat) that

...

> I understand that, I just wonder why nobody noticed before. It's been
> that way forever :)

Any proper tool that interfaces to snmp-like counters expects and deals with
worse: sudden counter resets.

And it has been that way forever :-)  So people who use such tools would
hardly notice any warp-arounds...

So, the question becomes: which tools are misbehaving?  Maybe they should
adopt snmp-like counter reset detection for peak filtering, and we could
leave 32-bit alone, and increase the counter size only on for 64-bit?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
