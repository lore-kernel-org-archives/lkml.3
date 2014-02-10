Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaBJVOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:14:49 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:35363 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaBJVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:14:47 -0500
Date: Mon, 10 Feb 2014 22:14:45 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] This extends tx_data and and iscsit_do_tx_data with the
 additional parameter flags and avoids sending multiple TCP packets in
 iscsit_fe_sendpage_sg
Message-ID: <20140210211445.GE19621@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	John Ogness <john.ogness@linutronix.de>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140208165732.GB22359@glanzmann.de>
 <1391879318.10160.108.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140208171531.GA23798@glanzmann.de>
 <1391886759.10160.114.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140209074027.GA8105@glanzmann.de>
 <20140209074227.GA8219@glanzmann.de>
 <1391949039.10160.129.camel@edumazet-glaptop2.roam.corp.google.com>
 <1392058718.17867.8.camel@haakon3.risingtidesystems.com>
 <20140210205634.GC19621@glanzmann.de>
 <1392066100.6615.55.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392066100.6615.55.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> Hmm.. I was not aware of high RTT for some packets.
> Can you spot this on the pcap you provided ?

with the latest patch as in:

(node-62) [~/work/linux-2.6] git diff | pbot
http://pbot.rmdir.de/CQwqI6b7wJProw_xaukmEg

with net.ipv4.tcp_min_tso_segs=2 we had this pcap:
https://thomas.glanzmann.de/tmp/tcp_auto_corking_on_patched_tcp_more_notlast.pcap.bz2
And here is the RTT TCP graph:
Wireshark > Statistics > TCP Stream Graph > Round Trip Time Graph
https://thomas.glanzmann.de/tmp/screenshot-mini-2014-02-10-22_04_30.png

with net.ipv4.tcp_min_tso_segs=8 we have this pcap:
https://thomas.glanzmann.de/tmp/tcp_auto_corking_on_patched_tcp_more_notlast_min_tso_segs_8.pcap.bz2
And here is the RTT TCP graph:
Wireshark > Statistics > TCP Stream Graph > Round Trip Time Graph

This gives us 0.0015 seconds RTT (1.5 ms)

Without TCP autocorking we had 0.0005 (0.5 ms).

https://thomas.glanzmann.de/tmp/screenshot-mini-2014-02-08-09:53:17.png

Cheers,
        Thomas
