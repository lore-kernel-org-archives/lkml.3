Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3AYTCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:02:09 -0500
Received: from mail.vapor.com ([83.220.149.2]:41053 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab3AYTCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:02:06 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 14:02:06 EST
Date: Fri, 25 Jan 2013 19:55:38 +0100
From: Ian Kumlien <pomac@vapor.com>
To: linux-kernel@vger.kernel.org
Subject: atl1c: networking bug - increasing counters with no data.
Message-ID: <20130125185537.GA15780@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

I have a atl1c networking card in my laptop - it's not connected since i
use wifi instead.

After a while of uptime it seems like it goes haywire, tools are
currently reporting data transfers of ~9GB/s

ifconfig eth0
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 48:5b:39:5e:b0:4b  txqueuelen 1000  (Ethernet)
        RX packets 324218491164960  bytes 324218491164960 (294.8 TiB)
        RX errors 1945310946989760  dropped 648436982329920  overruns 324218491164960  frame 1621092455824800
        TX packets 324218491164960  bytes 324218491164960 (294.8 TiB)
        TX errors 1296878259627135  dropped 0 overruns 324218491164960  carrier 648436982329920  collisions 1621092455824800

ethtool -i eth0
driver: atl1c
version: 1.0.1.0-NAPI
firmware-version: 
bus-info: 0000:04:00.0
supports-statistics: no
supports-test: no
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no

uptime
 19:45:20 up 1 day, 17:45,  8 users,  load average: 0.74, 1.79, 1.41

The only changes i have been able to spot was the __dev* cleanups... 

git log HEAD...v3.7.3 --format=oneline -- drivers/net/ethernet/atheros/atl1c/
1dd06ae8db716e17ec7e06244b858606edf378c0 drivers/net: fix up function prototypes after __dev* removals
093d369d4e8e8b6361317edd83935bdf8a0c83de net/atheros: remove __dev* attributes

And I'm currently running: v3.8-rc4-139-g1d85490

(It takes a while to recreate... )
