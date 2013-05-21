Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3EUObZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:31:25 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58113 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3EUObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <519B68A4.3010406@linux.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
 <519B632F.7040202@mellanox.com> <519B68A4.3010406@linux.intel.com>
From: Willem de Bruijn <willemb@google.com>
Date: Tue, 21 May 2013 10:30:53 -0400
Message-ID: <CA+FuTScYMPUsf0+67FAU0LBfuxhGT8JKyvL1WX=Rjomno75q2A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Alex Rosenbaum <alexr@mellanox.com>, Dave Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel <e1000-devel@lists.sourceforge.net>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 2. How is the logic aware of RSS and RFS?
>>
>> With TCP sockets, the driver knows the specific ring it need to poll so
>> this should be mapped and provide the best latency.
>
>
> This code is blissfully oblivious of RFS and RSS, it only assumes that the
> packets for a socket are likely to continue to come on the same queue.
> The code is designed to be correct even if you get your data on the wrong
> queue. (your performance will suffer but no more than that.)
>

For low latency, you don't want to have to wait for the IPI that RPS
sets to redirect packets to another CPU.  However, this feature works
extremely well with hardware flow steering (nfc/ntuple) and
accelerated RFS, where the device will enqueue directly on an rxqueue
owned exclusively by the destination cpu (if configured correctly).
