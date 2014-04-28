Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaD1UEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:04:46 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:22231
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbaD1UEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:04:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: RE: [PATCH V1 net-next 1/1] hyperv: Properly handle checksum offload
Thread-Topic: [PATCH V1 net-next 1/1] hyperv: Properly handle checksum
 offload
Thread-Index: AQHPYPuaDU0Q/0xe0UqEf9595APZYJsnS0KAgAAH/nA=
Date: Mon, 28 Apr 2014 18:31:56 +0000
Message-ID: <6a4748198dba455588493c4e95845330@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398484523-27596-1-git-send-email-kys@microsoft.com>
 <20140428.132347.778081265367223580.davem@davemloft.net>
In-Reply-To: <20140428.132347.778081265367223580.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(199002)(189002)(377454003)(76576001)(92566001)(99396002)(80976001)(31966008)(101416001)(19580405001)(86612001)(4396001)(83322001)(74316001)(76482001)(99286001)(80022001)(74502001)(86362001)(74662001)(79102001)(20776003)(46102001)(77096999)(87936001)(81342001)(50986999)(2656002)(33646001)(77982001)(66066001)(19580395003)(76176999)(54356999)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:FEDDCE3E.9CAA9E2A.79F061A7.E5FBA9.2027B;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, April 28, 2014 10:24 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; stable@kernel.org
> Subject: Re: [PATCH V1 net-next 1/1] hyperv: Properly handle checksum
> offload
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Fri, 25 Apr 2014 20:55:23 -0700
> 
> > @@ -467,6 +467,9 @@ static int netvsc_start_xmit(struct sk_buff *skb,
> struct net_device *net)
> >  	if (skb_is_gso(skb))
> >  		goto do_lso;
> >
> > +	if (skb->ip_summed != CHECKSUM_PARTIAL)
> > +		goto do_send;
> > +
> 
> There are many possible values of ip_summed, why would you go to
> do_send if for example it was set to CHECKSUM_COMPLETE?
> 
> I think you are just rushing this change, take your time and implement the fix
> properly.
> 
> For example, if you only expect two possible values here
> (CHECKSUM_PARTIAL and something else), design your test so that it only
> allows those two values and therefore you'll be documenting this invariant.

David,

I based this check on the check I see in tcp_v4_send_check() (and tcp_v6_send_check).
Looking at the code some more, it looks like if ip_summed is set to  CHECKSUM_NONE, the
software has computed the checksum and we can bypass the code for offloading the checksum.

Regards,

K. Y
