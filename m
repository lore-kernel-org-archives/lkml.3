Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3EMQK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:10:57 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:14127 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3EMQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:09:22 -0400
Message-ID: <1368461354.3305.17.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping policy
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Vick, Matthew" <matthew.vick@intel.com>, Dong Zhu <bluezhudong@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, "Dave Jones" <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 13 May 2013 17:09:14 +0100
In-Reply-To: <CDB65511.1CE8D%matthew.vick@intel.com>
References: <CDB65511.1CE8D%matthew.vick@intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19862.005
X-TM-AS-Result: No--22.905400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 15:48 +0000, Vick, Matthew wrote:
> On 5/13/13 3:07 AM, "Dong Zhu" <bluezhudong@gmail.com> wrote:
[...]
> >From 8a12932fd2a3bb5ca904bc72b20140247a5d81be Mon Sep 17 00:00:00 2001
> >From: Dong Zhu <bluezhudong@gmail.com>
> >Date: Mon, 13 May 2013 17:27:59 +0800
> >
> >Currently kernel only support setting the hw time stamping policy
> >through ioctl,now add a method to check which packets(Outgoing and
> >Incoming) are time stamped by nic.
> >
> >Add this to igb_get_ts_info, we can query this by using the GET_TS_INFO
> >ethtool command. Testing on I350 and 82576NS it seems work well.
> >
> >Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> >---
> > drivers/net/ethernet/intel/igb/igb_ethtool.c | 78
> >+++++++++++++++++++++++++++-
> > include/uapi/linux/ethtool.h                 |  3 ++
> > 2 files changed, 79 insertions(+), 2 deletions(-)
> 
> [...]
> 
> >diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> >index 0c9b448..06cdbc0 100644
> >--- a/include/uapi/linux/ethtool.h
> >+++ b/include/uapi/linux/ethtool.h
> >@@ -772,7 +772,10 @@ struct ethtool_sfeatures {
> >  * @so_timestamping: bit mask of the sum of the supported
> >SO_TIMESTAMPING flags
> >  * @phc_index: device index of the associated PHC, or -1 if there is none
> >  * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration
> >values
> >+ * @tx_reserved[0]: bit mask of the in use hwtstamp_tx_types enumeration
> >values
> >  * @rx_filters: bit mask of the supported hwtstamp_rx_filters
> >enumeration values
> >+ * @rx_reserved[0]: bit mask of the in use hwtstamp_rx_filters
> >enumeration
> >+ * values

Why would we keep calling a field 'reserved' once it's been given a
specific meaning?

> >  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
> >  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
> >-- 
> >1.7.11.7
> >
> >
> >-- 
> >Best Regards,
> >Dong Zhu
> 
> CCing Ben Hutchings, since now your patch is affecting ethtool.
[...]

Thanks, Matthew.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

