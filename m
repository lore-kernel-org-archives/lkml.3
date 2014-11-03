Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKCSeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:34:03 -0500
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:62720
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751906AbaKCSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:33:59 -0500
Date: Mon, 3 Nov 2014 19:33:45 +0100
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Sunil Kovvuri <sunil.kovvuri@gmail.com>, Robert Richter <rric@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network
 controller
Message-ID: <20141103183345.GK31556@rric.localhost>
References: <20141030165434.GW20170@rric.localhost>
 <20141030195458.2958d88a@urahara>
 <CA+sq2CfV-90CRvo-FCizkzoxHq-AsfOEDW2Z5pXtnNLNXCfTUg@mail.gmail.com>
 <20141103101651.1d664cc3@urahara>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141103101651.1d664cc3@urahara>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.192.205]
X-ClientProxiedBy: AM3PR04CA0048.eurprd04.prod.outlook.com (10.242.16.48) To
 CO2PR0701MB807.namprd07.prod.outlook.com (10.141.246.25)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0701MB807;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6069001)(6009001)(199003)(377454003)(164054003)(24454002)(51704005)(189002)(102836001)(76176999)(50986999)(31966008)(101416001)(33656002)(97756001)(54356999)(47776003)(20776003)(64706001)(62966003)(77096003)(77156002)(66066001)(50466002)(40100003)(46102003)(86362001)(92566001)(110136001)(93886004)(99396003)(4396001)(19580395003)(19580405001)(46406003)(83506001)(87976001)(120916001)(21056001)(105586002)(97736003)(92726001)(23726002)(122386002)(76506005)(106356001)(42186005)(95666004)(107046002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR0701MB807;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.11.14 10:16:51, Stephen Hemminger wrote:
> On Fri, 31 Oct 2014 22:44:11 +0530
> Sunil Kovvuri <sunil.kovvuri@gmail.com> wrote:
> 
> > On Fri, Oct 31, 2014 at 8:24 AM, Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > > On Thu, 30 Oct 2014 17:54:34 +0100
> > > Robert Richter <rric@kernel.org> wrote:
> > >
> > >> +#ifdef       VNIC_RSS_SUPPORT
> > >> +static int rss_config = RSS_IP_HASH_ENA | RSS_TCP_HASH_ENA | RSS_UDP_HASH_ENA;
> > >> +module_param(rss_config, int, S_IRUGO);
> > >> +MODULE_PARM_DESC(rss_config,
> > >> +              "RSS hash config [bits 8:0] (Bit0:L2 extended, 1:IP, 2:TCP, 3:TCP SYN, 4:UDP, 5:L4 extended, 6:ROCE 7:L3 bi-directional, 8:L4 bi-directional)");
> > >> +#endif
> > >
> > > This should managed  be via ethtool ETHTOOL_GRXFH rather than a module parameter.
> > Thanks, i will add setting hash options via ETHTOOL_SRXFH as well.
> > The idea here is to have a choice of hash while module load (through
> > module params) and if it needs to be changed runtime then
> > via Ethtool.
> > 
> > Sunil.
> 
> Network developers do not like vendor unique module parameters.
> Anything device specific doesn't work in a generic distro environment.

Do you accept unique module parameters in parallel to ethtool support
or should this be removed?

-Robert
