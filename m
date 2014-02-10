Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaBJVJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:09:37 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39001 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaBJVJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:09:35 -0500
Message-ID: <1392066574.6615.57.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] This extends tx_data and and iscsit_do_tx_data with the
 additional parameter flags and avoids sending multiple TCP packets in
 iscsit_fe_sendpage_sg
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: dev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Feb 2014 13:09:34 -0800
In-Reply-To: <1392066100.6615.55.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140208150001.GI20512@glanzmann.de>
	 <1391871986.10160.105.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140208165732.GB22359@glanzmann.de>
	 <1391879318.10160.108.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140208171531.GA23798@glanzmann.de>
	 <1391886759.10160.114.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140209074027.GA8105@glanzmann.de> <20140209074227.GA8219@glanzmann.de>
	 <1391949039.10160.129.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1392058718.17867.8.camel@haakon3.risingtidesystems.com>
	 <20140210205634.GC19621@glanzmann.de>
	 <1392066100.6615.55.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 13:01 -0800, Eric Dumazet wrote:
> On Mon, 2014-02-10 at 21:56 +0100, Thomas Glanzmann wrote:
> > Hello Nab,
> > 
> > > This looks correct to me.  Thomas, once your able to confirm please
> > > include your 'Tested-by' and I'll include for the next -rc3 PULL
> > > request.
> > 
> > Eric is currently reviewing our latest iteration with MSG_MORE for
> > kernel_sendmsg and MSG_MORE | MSG_SENDPAGE_NOTLAST for sendpage. However
> > with the last iteration we had again a high RTT for some packets. But
> > than Eric let me tune net.ipv4.tcp_min_tso_segs to 8 and the RTT went
> > down to what it used before auto corking was enabled. At least almost.
> > 
> 
> Hmm.. I was not aware of high RTT for some packets.
> 
> Can you spot this on the pcap you provided ?

offlist

Also please make sure you have this patch :

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=4a5ab4e224288403b0b4b6b8c4d339323150c312


