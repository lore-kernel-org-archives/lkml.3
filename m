Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab3ENS7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:59:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:27168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3ENS71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:59:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="313541016"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Dong Zhu <bluezhudong@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "Vick, Matthew" <matthew.vick@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
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
        "Abodunrin, Akeem G" <akeem.g.abodunrin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] igb: add a method to get the nic hw time stamping policy
Thread-Topic: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Thread-Index: AQHOTlAy97bKChIyG0OhdaLruqvYKZkAqF6AgAFplICAADH4AIAAk3oAgAAm2gCAAF3jAIABjeyAgAAhVEA=
Date: Tue, 14 May 2013 18:59:24 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58564E0BA3@ORSMSX104.amr.corp.intel.com>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <518E7723.5010003@cogentembedded.com>
 <20130512142555.GI8399@zhudong.nay.redhat.com>
 <20130512172446.GA2484@netboy>
 <20130513021236.GJ8399@zhudong.nay.redhat.com>
 <20130513043140.GA2567@netboy>
 <20130513100742.GM8399@zhudong.nay.redhat.com>
 <20130514095155.GO8399@zhudong.nay.redhat.com>
In-Reply-To: <20130514095155.GO8399@zhudong.nay.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4EIxejG009923

Hello,

> -----Original Message-----
> From: Dong Zhu [mailto:bluezhudong@gmail.com]
> Sent: Tuesday, May 14, 2013 2:52 AM
> To: Keller, Jacob E; Ben Hutchings; Vick, Matthew; Richard Cochran
> Cc: Sergei Shtylyov; Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce
> W; Wyborny, Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz
> Jr, Peter P; Duyck, Alexander H; Ronciak, John; Dave, Tushar N;
> Abodunrin, Akeem G; David S. Miller; Paul E. McKenney; David Howells;
> Dave Jones; Thomas Gleixner; linux-kernel@vger.kernel.org; e1000-
> devel@lists.sourceforge.net; netdev@vger.kernel.org
> Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping
> policy
> 
> Hi,
> 
> > I modified this patch and added the method to igb_get_ts_info
> function.
> > For 82576 nic, through this method we can easily check which type of
> packets
> > are time stamped now, such as (HWTSTAMP_FILTER_PTP_V1_L4_SYNC
> and
> > HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ), then change or disable it
> up to your requests.
> > I think it is convenient.The origial GET_TS_INFO method can only show
> the deviceâ€™s
> > time stamping capabilities which nics supported.
> 
> Through this method we can easily check which type of packets are
> timestamped currently, it is useful because that we use the
> hwstamp_ctl
> set time stamping policy first then we could verify what type of packets
> does the nic timestamp and then do some other testing(regression) for
> each
> policy.No matter PTP is running or not we can make sure whether
> timestamp packets
> could cause other general network problems through viewing and
> setting the
> timestamp policy.
> 

Correct. However, the ioctl already modifies the value of the hwtstamp_config so that it will tell you which packets are being timestamped. As long as the filter is a match for one of the supported filters, it will return that value, otherwise it will return HWTSTAMP_FILTER_SOME. But that means  it will timestamp at least what you request. If you are concerned about returning more specifically what the driver is doing in FILTER_SOME mode, you could extend the filters, and add the one you're missing, but it would need to be common and justified enough... Which it probably isn't as the current list is pretty comprehensive.

There is no real need to add a second field to get this without setting, as you can simply call it with a new value, and then get the value you need. Effectively, if you don't know the value is correct, just try to set it how you want, and check the return value plus the hwtstamp_config structure which will be MODIFIED by the hwtstamp ioctl.

There is absolutely no reason to add this as a new field which would remove the ability to extend hwtstamp_ioctl in the future should that ever be necessary!!

> My original idea is that:
> The implementation of this method is calling the ioctl call, in order
> not to break the userland ABI I use the flags field of hwtstamp_config,
> as it has no definition yet.
> 
That would remove the ability to extend the ioctl when it's really necessary.

>   - For I350 it only supports two types HWTSTAMP_FILTER_NONE and
> HWTSTAMP_FILTER_ALL
>     for timestamping. It is easy to handle just return the value to flags.
> 
>   - For 82576NS it has more individual filters, so I need to do the
>     judement in the igb_ptp_hwtstamp_ioctl function for different nics,
>     the code of judgement might be reduplicated with
> igb_get_ts_info,then do
>     the OR operation for filters then return to the flags.
> 

What are you trying to achieve. When you call hwtstamp_ioctl on the igb driver, it will modify the passed in structure (hwtstamp_config) and set it's rx_filter type to the current value after the function is called. Upon return, your application can check the value and then perform regression tests or what have you against that value. You already have this information. You don't need a new method to fix it.

If you are debugging a driver, you can have that driver print data to the kernel print buffer or the ftrace buffer in order to determine what is being done. But your application can already get the set filter and compare to the expected filter. Documentation/timestamping/timestamping.c already shows you how to do this!

> Could tell me whether the above method(ioctl) is feasible and better
> than this
> one (ethtool)?
> 
> IMO checking this through the ethtool GET_TS_INFO is so convenient
> without breaking any userland ABIs. Do you think so ?
> 
Modifying GET_TS_INFO would be potentially breaking a userland ABI.. Again, no one understands what you are trying to do that can't already be done via hwtstamp_ioctl (unmodified!) We understand what you are wanting, but telling you that it can already be done!

> >
> > I use the tx_reserved[0] and rx_reserved[0] to restore the
> hwtstamp_tx_types and
> > hwtstamp_rx_filters enumeration values.
> >
> > I test it on I350 and 82576NS nics and it works as expect.
> >
> > Could help reviewing it again ? Any comments would be appreciated.
> >
> 


- Jake
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
