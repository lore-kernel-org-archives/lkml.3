Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3ATPsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:48:50 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:48753 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360Ab3ATPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:48:49 -0500
Message-ID: <50FC11DE.6000707@linux-ipv6.org>
Date: Mon, 21 Jan 2013 00:48:46 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: stephan.gatzka@gmail.com
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] firewire net: Ensure checksumming in upper layer.
References: <50FBA02C.9030203@linux-ipv6.org> <20130120105058.1aee26c4@stein> <50FBC8D5.50205@linux-ipv6.org> <50FC0353.8090902@gmail.com> <50FC08E5.6020903@linux-ipv6.org> <50FC0A6C.205@gmail.com>
In-Reply-To: <50FC0A6C.205@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Gatzka wrote:
> 
>> "Off-link source" means the source exists on the different L2
>> network.  In other words, source is connected via router(s).
>>
>>           ethernet             firewire
>>   Host -------------- Router ------------ Host
>>
> 
> O.k., understood. But the receiving router verifies the checksum of incoming packets and sends them on the firewire link. On firewire we have CRC checksums to ensure the integrity of packets.
> 
> I agree with your patch but I don't see why we should check them in the driver. I thought your patch will ensure that the checksums will be verified in the upper layers.

Routers do not inspect whole packet.
For IPv4, we have IP checksum, but routers (usually) do not check
upper-layer (e.g. UDP) checksum.
For IPv6, we do not have IP checksum.

CHECKSUM_UNNECESSARY means the driver has verified upper layer
(e.g. TCP/UDP) checksum.  Modern hardware can perform upper-layer
checksumming as well. But of course, not all drivers are required
to verify the upper-layer checksum; if the driver do not verify
checksum in the packet, just say CHECKSUM_NONE.

Regards,

--yoshfuji
