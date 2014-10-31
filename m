Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaJaROO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:14:14 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40927 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaJaRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:14:13 -0400
MIME-Version: 1.0
In-Reply-To: <20141030195458.2958d88a@urahara>
References: <20141030165434.GW20170@rric.localhost>
	<20141030195458.2958d88a@urahara>
Date: Fri, 31 Oct 2014 22:44:11 +0530
Message-ID: <CA+sq2CfV-90CRvo-FCizkzoxHq-AsfOEDW2Z5pXtnNLNXCfTUg@mail.gmail.com>
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network controller
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Robert Richter <rric@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 8:24 AM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Thu, 30 Oct 2014 17:54:34 +0100
> Robert Richter <rric@kernel.org> wrote:
>
>> +#ifdef       VNIC_RSS_SUPPORT
>> +static int rss_config = RSS_IP_HASH_ENA | RSS_TCP_HASH_ENA | RSS_UDP_HASH_ENA;
>> +module_param(rss_config, int, S_IRUGO);
>> +MODULE_PARM_DESC(rss_config,
>> +              "RSS hash config [bits 8:0] (Bit0:L2 extended, 1:IP, 2:TCP, 3:TCP SYN, 4:UDP, 5:L4 extended, 6:ROCE 7:L3 bi-directional, 8:L4 bi-directional)");
>> +#endif
>
> This should managed  be via ethtool ETHTOOL_GRXFH rather than a module parameter.
Thanks, i will add setting hash options via ETHTOOL_SRXFH as well.
The idea here is to have a choice of hash while module load (through
module params) and if it needs to be changed runtime then
via Ethtool.

Sunil.
