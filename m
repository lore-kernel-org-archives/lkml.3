Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaIQCnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:43:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:64550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaIQCnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,537,1406617200"; 
   d="scan'208";a="592385081"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: David Miller <davem@davemloft.net>
CC: "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "rayagond@vayavyalabs.com" <rayagond@vayavyalabs.com>,
        "vbridgers2013@gmail.com" <vbridgers2013@gmail.com>,
        "srinivas.kandagatla@st.com" <srinivas.kandagatla@st.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 3/4] net: stmmac: add support for Intel Quark X1000
Thread-Topic: [PATCH v2 3/4] net: stmmac: add support for Intel Quark X1000
Thread-Index: AQHPztbom04Iz4URhUOKiyu70+M/jZwB2NUwgAHEYYCAAP0oIA==
Date: Wed, 17 Sep 2014 02:41:39 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7E9DCA@PGSMSX102.gar.corp.intel.com>
References: <07ca9d2c89cf4f01037c98e3314dd035e4d2ee34.1410416224.git.hock.leong.kweh@intel.com>
	<20140912.181423.1831537443587796533.davem@davemloft.net>
	<F54AEECA5E2B9541821D670476DAE19C2B7E99A7@PGSMSX102.gar.corp.intel.com>
 <20140916.150037.1715537913178712290.davem@davemloft.net>
In-Reply-To: <20140916.150037.1715537913178712290.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, September 17, 2014 3:01 AM
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> Date: Mon, 15 Sep 2014 12:42:03 +0000
> 
> > The only things to differentiate them is PCI BUS DEVICE FUNCTION
> > (Bus:Dev:Func) number which are fix numbers 00:20:6 for port 1 and
> > 00:20:7 for port 2 stated in Quark X1000 datasheet.
> 
> Match on the PCI device class, which must be
> PCI_CLASS_NETWORK_ETHERNET or similar.
> 
> The pci_device_id used for probing supports matching on this directly.
> .

Hi David,

Thanks for the pointer. I did a quickly checking on the class number to see if
I could use it for differentiation the ports number. Whereas I found them 
both have the same class number as well. Below shows the "lspci" dump to 
all the PCI devices on Quark X1000 Galileo board (Ethernet controllers are
00:14.6 and 00:14.7). Very unfortunately we are unlikely to use the class 
number as well as pci_device_id for the differentiation.
Thanks.

root@quark:~# lspci -m
00:00.0 "Class 0600" "8086" "0958" "8086" "095e"
00:14.0 "Class 0805" "8086" "08a7" "8086" "08a7"
00:14.1 "Class 0700" "8086" "0936" "8086" "0936"
00:14.2 "Class 0c03" "8086" "0939" "8086" "0939"
00:14.3 "Class 0c03" "8086" "0939" "8086" "0939"
00:14.4 "Class 0c03" "8086" "093a" "8086" "093a"
00:14.5 "Class 0700" "8086" "0936" "8086" "0936"
00:14.6 "Class 0200" "8086" "0937" "8086" "0937"
00:14.7 "Class 0200" "8086" "0937" "8086" "0937"
00:15.0 "Class 0c80" "8086" "0935" "8086" "0935"
00:15.1 "Class 0c80" "8086" "0935" "8086" "0935"
00:15.2 "Class 0c80" "8086" "0934" "8086" "0934"
00:17.0 "Class 0604" "8086" "11c3" "8086" "11c3"
00:17.1 "Class 0604" "8086" "11c4" "8086" "11c4"
00:1f.0 "Class 0601" "8086" "095e" "8086" "095e"
root@quark:~# lspci -k
00:00.0 Class 0600: 8086:0958 iosf_mbi_pci
00:14.0 Class 0805: 8086:08a7 sdhci-pci
00:14.1 Class 0700: 8086:0936 serial
00:14.2 Class 0c03: 8086:0939
00:14.3 Class 0c03: 8086:0939 ehci-pci
00:14.4 Class 0c03: 8086:093a ohci-pci
00:14.5 Class 0700: 8086:0936 serial
00:14.6 Class 0200: 8086:0937 stmmaceth
00:14.7 Class 0200: 8086:0937
00:15.0 Class 0c80: 8086:0935
00:15.1 Class 0c80: 8086:0935
00:15.2 Class 0c80: 8086:0934
00:17.0 Class 0604: 8086:11c3 pcieport
00:17.1 Class 0604: 8086:11c4 pcieport
00:1f.0 Class 0601: 8086:095e
root@quark:~#


Regards,
Wilson

