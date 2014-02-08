Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaBHRPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:15:35 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:60998 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBHRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:15:33 -0500
Date: Sat, 8 Feb 2014 18:15:31 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION f54b311142a92ea2e42598e347b84e1655caf8e3 tcp auto
 corking slows down iSCSI file system creation by factor of 70 [WAS: 4 TB
 VMFS creation takes 15 minutes vs 26 seconds]
Message-ID: <20140208171531.GA23798@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	John Ogness <john.ogness@linutronix.de>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1391865273.10160.76.camel@edumazet-glaptop2.roam.corp.google.com>
 <1391866389.10160.80.camel@edumazet-glaptop2.roam.corp.google.com>
 <1391867404.10160.88.camel@edumazet-glaptop2.roam.corp.google.com>
 <1391868816.10160.93.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208141905.GG20512@glanzmann.de>
 <1391869805.10160.97.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208150001.GI20512@glanzmann.de>
 <1391871986.10160.105.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208165732.GB22359@glanzmann.de>
 <1391879318.10160.108.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391879318.10160.108.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> Yep, but the problem (at least on your pcap), is about sending the 48
> bytes headers in  TCP segment of its own, then the 512 byte payload in
> a separate segment.

I agree.

> I suspect the sendpage() is only used for the payload. No need for
> MSG_MORE here.

I see.

> The MSG_MORE would need to be set on the first part (48 bytes header),
> so that TCP stack will defer the push of the segment at the time the 512
> bytes payload is added.

The iSCSI target uses one function to send all outbound data. So in
order to do it right every function that is sending data in multiple
chunks need to mark it correctly. Of course someone could also do some
wild guessing and saying that everything that is below 512 Bytes gets
pushed out. I wonder what Nab has to say about this?

Cheers,
        Thomas
