Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3KNS0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:26:22 -0500
Received: from mout.gmx.net ([212.227.15.15]:63539 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3KNS0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:26:13 -0500
Date: Thu, 14 Nov 2013 19:26:09 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Joe Perches <joe@perches.com>
Cc: Marek Vasut <marex@denx.de>, wsa@the-dreams.de, jacmet@sunsite.dk,
        baohua.song@csr.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: busses: Do not print error message in syslog if no
 ACK received
Message-ID: <20131114182609.GB2133@thinkpad.fritz.box>
References: <1384278336-3694-1-git-send-email-wernerandy@gmx.de>
 <201311121933.41038.marex@denx.de>
 <20131113182415.GA1458@thinkpad.fritz.box>
 <201311132024.06853.marex@denx.de>
 <1384436392.15774.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384436392.15774.2.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:k/5S2CInDoLE4U9Xu84ohYIskPoeOYOKJcCkOZ9X+3a0i7V4pI8
 duf/ie0LjbOdDN3iHIL15jTLBlgotYeSGjexy/0JYSoIYNEcQLk1RiAzXBhqLsU2LvuyNZ2
 ym935jG71bAK/tB1KeG2qQ7JQCfGMJ3/YaXZeQqDhJ2Sc6iftx1g0mkuNifuvRszUXa37Vd
 23dOQGrYAGdLQ63XvaWkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:39:52AM -0800, Joe Perches wrote:
> On Wed, 2013-11-13 at 20:24 +0100, Marek Vasut wrote:
> > > On Tue, Nov 12, 2013 at 07:33:40PM +0100, Marek Vasut wrote:
> > > > > > That is because if you look at the only caller of this function,
> > > > > > which is pch_i2c_wait_for_check_xfer(), you will see that at the
> > > > > > only place where pch_i2c_getack() is called there is already
> > > > > > pch_dbg():
> > > > > > 
> > > > > > 369         if (pch_i2c_getack(adap)) {
> > > > > > 370                 pch_dbg(adap, "Receive NACK for slave address"
> > > > > > 371                         "setting\n");
> > > > > > 372                 return -EIO;
> > > > > > 373         }
> > > 
> > > Sorry i misunderstood that. You are absolutly right, thats the best
> > > solution for that. Remove the pch_err at getack so that only the pch_dbg
> > > get printed where getack is called. This should be enough information.
> > 
> > No problem ;-)
> 
> If this is the approach taken, please coalesce the format.
> As is there's a missing space between address and setting.
> This should be:
> 
> 		pch_dbg(adap, "Received NACK for slave address setting\n");
> 
> 
Hi,
yes you are right, i will also add it and resand the patch in a few days.

regards 
Andy
