Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaJLUGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:06:13 -0400
Received: from mail-am1on0062.outbound.protection.outlook.com ([157.56.112.62]:4640
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752682AbaJLUGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:06:08 -0400
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 16:06:07 EDT
Message-ID: <543ADBA3.5030305@mellanox.com>
Date: Sun, 12 Oct 2014 21:50:59 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: yinpeijun <yinpeijun@huawei.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lichunhe@huawei.com>, <wangfakai@huawei.com>
Subject: Re: vxlan gro problem ?
References: <5434FA02.8070608@huawei.com>
In-Reply-To: <5434FA02.8070608@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.158.157.135]
X-ClientProxiedBy: DB3PR01CA0067.eurprd01.prod.exchangelabs.com
 (10.242.133.170) To AMSPR05MB0580.eurprd05.prod.outlook.com (10.242.80.140)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB0580;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(51704005)(199003)(377454003)(479174003)(53754006)(189002)(24454002)(50986999)(42186005)(101416001)(76176999)(31966008)(54356999)(65816999)(19580395003)(65956001)(66066001)(102836001)(80316001)(20776003)(19580405001)(40100003)(47776003)(64706001)(50466002)(15975445006)(87266999)(21056001)(64126003)(15202345003)(83506001)(85852003)(122386002)(4396001)(87976001)(95666004)(36756003)(97736003)(80022003)(105586002)(110136001)(106356001)(77096002)(46102003)(85306004)(33656002)(76482002)(23746002)(59896002)(86362001)(107046002)(99396003)(92726001)(92566001)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:AMSPR05MB0580;H:[10.43.2.95];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: Mellanox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/2014 10:46 AM, yinpeijun wrote:
> Hi all,
>          recently Linux 3.14 has been released and I find the networking has added udp gro and vxlan gro funtion, then I use the redhat 7.0(there is also add this funtion)
> to test, I use kernel vxlan module and  create a vxlan device then attach the device to  ovs  bridge , the configure as follow:
>         root@25:~$ ip link
>          15: vxlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master ovs-system state UNKNOWN mode DEFAULT
>              link/ether be:e1:ae:3d:8b:f2 brd ff:ff:ff:ff:ff:ff
>          16: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc mq master ovs-system state UNKNOWN mode DEFAULT qlen 5000
>         
>         root@25:~$ ovs-vsctl show
>          aa1294f3-9952-4393-b2b5-54e9a6eb76ee
>          Bridge ovs-vx
>              Port ovs-vx
>                  Interface ovs-vx
>                      type: internal
>              Port "vnet0"
>                  Interface "vnet0"
>              Port "vxlan0"
>                  Interface "vxlan0"
>          ovs_version: "2.0.2"
>
> vnet0 is a vm backend device,  and the end is the same configuration. then I use netperf to test throughput  in vm (netperf -H **** -t TCP_STREAM -l 10 -- -m 1460),
> the result is 3-4 Gbit/sec, the  improvement  is not obvious,   and I also confused there is no aggregation  packets (length > mtu) in the end vm.   so I want to know what
> wrong ?   or how to test the function ?
>

As things are set in 3.14 and AFAIK also in RHEL 7.0, for GRO/VXLAN to 
come into play you need to run over a NIC which supports RX checksum 
offload too, is this the case?

Also, the configuration you run with isn't the typical play of VXLAN 
with OVS... I didn't try it out and this week being out to LPC.

Did you try the usual track of running OVS VXLAN port?e.g as explained 
in the Example section of [1]

Or.

[1] http://community.mellanox.com/docs/DOC-1446

Or.


