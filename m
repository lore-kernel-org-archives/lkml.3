Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaDOL5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:57:45 -0400
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:47381 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDOL5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:57:44 -0400
From: Sathya Perla <Sathya.Perla@Emulex.Com>
To: "Li, ZhenHua" <zhen-hual@hp.com>
CC: Subramanian Seetharaman <subbu.seetharaman@Emulex.Com>,
        Ajit Khaparde <Ajit.Khaparde@Emulex.Com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Topic: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Index: AQHPWHZ0bsT8dc/t9U2+WUWO6psh85sSUZaAgACFnwD//7jMgA==
Date: Tue, 15 Apr 2014 11:57:41 +0000
Message-ID: <069bdb52-6176-407a-b7fc-3f23a944a529@CMEXHTCAS2.ad.emulex.com>
References: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
 <b4855c2a-5a63-47a5-ba61-f9ce736f6401@CMEXHTCAS1.ad.emulex.com>
 <534CF596.3010609@hp.com>
In-Reply-To: <534CF596.3010609@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.141.147]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Li, ZhenHua [mailto:zhen-hual@hp.com]
> 
> Because netif_running() is called in netif_device_detach and
> netif_device_attach. To avoid dev status changed while
> netif_device_detach/attach is not finished, I think a rtnl_lock and
> unlock should be called to avoid this.

Ok. I'd like to then factor the code slightly differently by using
routines like this:

be_close_sync() {
	rtnl_lock();

  	netif_device_detach(netdev);
   	if (netif_running(netdev))
   		be_close(netdev);

	rtnl_unlock();
}

and similarly for be_open_sync()

And, I'd need some time to test these flows too.
Would you be OK with this?

thanks,
-Sathya
