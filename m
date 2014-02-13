Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaBMTxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:53:43 -0500
Received: from fep11.mx.upcmail.net ([62.179.121.31]:61002 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBMTxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:53:40 -0500
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <52FD22B1.4070301@odi.ch>
Date: Thu, 13 Feb 2014 20:53:21 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: xfrm: is pmtu broken with ESP tunneling?
References: <52F890D2.2060109@odi.ch> <20140211023258.GC11150@order.stressinduktion.org> <52FA8618.5030509@odi.ch> <20140213000115.GH11150@order.stressinduktion.org>
In-Reply-To: <20140213000115.GH11150@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 01:01 AM, Hannes Frederic Sowa wrote:
> Could you try either dropwatch or perf script net_dropmonitor and flood the
> network with the problematic packets. From the traces we could see where the
> packets get dropped without notification in the kernel.

Not much to see, unfortunately. The COUNT doesn't reflect the number packets 
that I am missing.

                  LOCATION                    OFFSET                     COUNT 

      ieee80211_iface_work                       208                         1

> Strange that the problem disappears if you enable no_pmtu_disc then.

It seems with PMTU the initial mtu is the one of the device (1500). So the 
original packet will have that size, but is subsequently wrapped into ESP and 
UDP, which add to that size. And the final packet is then larger than the device 
MTU... I know nothing about the ip / xfrm kernel code, so it's hard for me to 
verify if that theory is real.

Thanks,

Ortwin
