Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaBHOaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 09:30:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59378 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaBHOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 09:30:07 -0500
Message-ID: <1391869805.10160.97.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: REGRESSION f54b311142a92ea2e42598e347b84e1655caf8e3 tcp auto
 corking slows down iSCSI file system creation by factor of 70 [WAS: 4 TB
 VMFS creation takes 15 minutes vs 26 seconds]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 08 Feb 2014 06:30:05 -0800
In-Reply-To: <20140208141905.GG20512@glanzmann.de>
References: <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
	 <20140207051500.GB10916@glanzmann.de> <20140207075536.GB17815@glanzmann.de>
	 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
	 <20140207205142.GA8609@glanzmann.de> <20140208093808.GD16336@glanzmann.de>
	 <1391865273.10160.76.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1391866389.10160.80.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1391867404.10160.88.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1391868816.10160.93.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140208141905.GG20512@glanzmann.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 15:19 +0100, Thomas Glanzmann wrote:
> Hello Eric,

> I get the idea. However I'm a little bit confused, when I do a 'git grep
> MSG_MORE' I don't see much references in the Linux kernel who use it at
> all. So do you have an example for me where this flags needs to be
> applied?

Idea would be to set this flag when calling sendmsg() of the 48 bytes of
the header, and not set it on the sendmsg() of the 512 bytes of the
payload.

iscsi_sw_tcp_xmit_segment() already adds MSG_MORE, but
it would be nice to add a new _initial_ flags parameter to
iscsi_sw_tcp_xmit_segment()



