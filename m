Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3FGOaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:30:35 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62470 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3FGOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:30:23 -0400
Message-ID: <1370615420.24311.425.camel@edumazet-glaptop>
Subject: RE: Scaling problem with a lot of AF_PACKET sockets on different
 interfaces
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Mike Galbraith <bitbucket@online.de>,
        "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Fri, 07 Jun 2013 07:30:20 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B727D@saturn3.aculab.com>
References: <51B1CA50.30702@telenet.dn.ua>
	 <1370608871.5854.64.camel@marge.simpson.net>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B727B@saturn3.aculab.com>
	 <1370613289.24311.419.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B727D@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 15:09 +0100, David Laight wrote:
> > > Looks like the ptype_base[] should be per 'dev'?
> > > Or just put entries where ptype->dev != null_or_dev on a per-interface
> > > list and do two searches?
> > 
> > Yes, but then we would have two searches instead of one in fast path.
> 
> Usually it would be empty - so the search would be very quick!

quick + quick + quick + quick + quick == not so quick ;)

Plus adding another code for /proc/net/packet

Plus adding the xmit side (AF_PACKET captures receive and xmit)



