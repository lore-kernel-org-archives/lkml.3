Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3ATPKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 10:10:32 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:48708 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028Ab3ATPKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 10:10:31 -0500
Message-ID: <50FC08E5.6020903@linux-ipv6.org>
Date: Mon, 21 Jan 2013 00:10:29 +0900
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
References: <50FBA02C.9030203@linux-ipv6.org> <20130120105058.1aee26c4@stein> <50FBC8D5.50205@linux-ipv6.org> <50FC0353.8090902@gmail.com>
In-Reply-To: <50FC0353.8090902@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Gatzka wrote:
> 
>>> Indeed neither the device nor the lower drivers check protocol checksums.
>>> But the CRCs of the encapsulating 1394 packets are checked in hardware.
>>> Shall protocol checksums be verified regardless?
>>
>> Yes, because packets may come from off-link source.
>>
> 
> Hm, I can't see any off-link packets coming from fwnet_finish_incoming_packet()
> 
> So I wont verify checksums in the driver.

"Off-link source" means the source exists on the different L2
network.  In other words, source is connected via router(s).

         ethernet             firewire
 Host -------------- Router ------------ Host

--yoshfuji
