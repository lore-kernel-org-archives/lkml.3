Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaBEUoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:44:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50921 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaBEUoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:44:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,788,1384300800"; 
   d="scan'208";a="98398059"
Message-ID: <52F2A282.5040502@citrix.com>
Date: Wed, 5 Feb 2014 20:43:46 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, Michael Chan <mchan@broadcom.com>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: igb and bnx2: "NETDEV WATCHDOG: transmit queue timed out" when
 skb has huge linear buffer
References: <52EAA31B.1090606@schaman.hu>	 <1391114048.4804.2.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>	 <52EBA51E.808@citrix.com> <1391543271.4804.44.camel@LTIRV-MCHAN1.corp.ad.broadcom.com> <52F29DDC.7010908@citrix.com>
In-Reply-To: <52F29DDC.7010908@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.19.43]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 20:23, Zoltan Kiss wrote:
> On 04/02/14 19:47, Michael Chan wrote:
>> On Fri, 2014-01-31 at 14:29 +0100, Zoltan Kiss wrote:
>>> [ 5417.275472] WARNING: at net/sched/sch_generic.c:255
>>> dev_watchdog+0x156/0x1f0()
>>> [ 5417.275474] NETDEV WATCHDOG: eth1 (bnx2): transmit queue 2 timed out
>>
>> The dump shows an internal IRQ pending on MSIX vector 2 which matches
>> the the queue number that is timing out.  I don't know what happened to
>> the MSIX and why the driver is not seeing it.  Do you see an IRQ error
>> message from the kernel a few seconds before the tx timeout message?
>
> I haven't seen any IRQ related error message. Note, this is on Xen
> 4.3.1. Now I have new results with a reworked version of the patch,
> unfortunately it still has this issue. Here is a bnx2 dump, lspci
> output and some Xen debug output (MSI and interrupt bindings, I have
> more if needed).

You need debug-keys 'Q' as well to map between the PCI devices and Xen IRQs

~Andrew
