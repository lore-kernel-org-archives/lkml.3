Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaHFPWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:22:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:32272 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaHFPWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:22:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,812,1400050800"; 
   d="scan'208";a="572581723"
Message-ID: <53E24800.4030102@intel.com>
Date: Wed, 06 Aug 2014 08:21:36 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Koehrer Mathias <mathias.koehrer@etas.com>,
        Nick Krause <xerofoify@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix e1000e with Intel 82572EI that has no hardware timestamp
 support
References: <be459158bb5c46fcaf73129858342da4@FE-MBX1012.de.bosch.com> <53E23BEF.9030701@cogentembedded.com> <1407337757.772491.149802333.5E523CB0@webmail.messagingengine.com>
In-Reply-To: <1407337757.772491.149802333.5E523CB0@webmail.messagingengine.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 08:09 AM, Henrique de Moraes Holschuh wrote:
> On Wed, Aug 6, 2014, at 11:30, Sergei Shtylyov wrote:
>> On 8/6/2014 6:27 PM, Koehrer Mathias (ETAS/ESW5) wrote:
>>
>>> With the Intel 82527EI (driver: e1000e) there is an issue when running
>>> the ptpd2 program, that leads to a kernel oops.
>>> The reason is here that in e1000_xmit_frame() a work queue will be
>>> scheduled that has not been initialized in this case.
>>> The work queue "tx_hwstamp_work" will only be initialized if
>>> adapter->flags & FLAG_HAS_HW_TIMESTAMP set.
>>> This check is missing in e1000_xmit_frame().
>>
>>> The following patch adds the missing check.
>>
>>     OK, but this time you forgot your sign-off. :-)
> 
> Also, shouldn't the added test be inside the unlikely() ?
> 

That shouldn't be necessary, but it might be better to place the new
check after the unlikely.  So you do the unlikely check first, then the
adapter check to see if we support Tx timestamping.  That way we can
avoid any unnecessary checks in the adapter structure.

Thanks,

Alex
