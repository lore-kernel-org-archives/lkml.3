Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaKCUZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:25:42 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50727 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaKCUZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:25:40 -0500
Date: Mon, 3 Nov 2014 12:25:25 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Robert Richter <robert.richter@caviumnetworks.com>
Cc: Sunil Kovvuri <sunil.kovvuri@gmail.com>, Robert Richter <rric@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network
 controller
Message-ID: <20141103122525.22679b68@urahara>
In-Reply-To: <20141103183345.GK31556@rric.localhost>
References: <20141030165434.GW20170@rric.localhost>
	<20141030195458.2958d88a@urahara>
	<CA+sq2CfV-90CRvo-FCizkzoxHq-AsfOEDW2Z5pXtnNLNXCfTUg@mail.gmail.com>
	<20141103101651.1d664cc3@urahara>
	<20141103183345.GK31556@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014 19:33:45 +0100
Robert Richter <robert.richter@caviumnetworks.com> wrote:

> On 03.11.14 10:16:51, Stephen Hemminger wrote:
> > On Fri, 31 Oct 2014 22:44:11 +0530
> > Sunil Kovvuri <sunil.kovvuri@gmail.com> wrote:
> > 
> > > On Fri, Oct 31, 2014 at 8:24 AM, Stephen Hemminger
> > > <stephen@networkplumber.org> wrote:
> > > > On Thu, 30 Oct 2014 17:54:34 +0100
> > > > Robert Richter <rric@kernel.org> wrote:
> > > >
> > > >> +#ifdef       VNIC_RSS_SUPPORT
> > > >> +static int rss_config = RSS_IP_HASH_ENA | RSS_TCP_HASH_ENA | RSS_UDP_HASH_ENA;
> > > >> +module_param(rss_config, int, S_IRUGO);
> > > >> +MODULE_PARM_DESC(rss_config,
> > > >> +              "RSS hash config [bits 8:0] (Bit0:L2 extended, 1:IP, 2:TCP, 3:TCP SYN, 4:UDP, 5:L4 extended, 6:ROCE 7:L3 bi-directional, 8:L4 bi-directional)");
> > > >> +#endif
> > > >
> > > > This should managed  be via ethtool ETHTOOL_GRXFH rather than a module parameter.
> > > Thanks, i will add setting hash options via ETHTOOL_SRXFH as well.
> > > The idea here is to have a choice of hash while module load (through
> > > module params) and if it needs to be changed runtime then
> > > via Ethtool.
> > > 
> > > Sunil.
> > 
> > Network developers do not like vendor unique module parameters.
> > Anything device specific doesn't work in a generic distro environment.
> 
> Do you accept unique module parameters in parallel to ethtool support
> or should this be removed?

If there is ethtool support the module parameters are not needed.
Unneeded code is to be avoided.
