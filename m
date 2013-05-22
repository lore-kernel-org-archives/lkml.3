Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3EVSvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:51:36 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63064 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3EVSve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:51:34 -0400
Message-ID: <519D13AE.4020807@gmail.com>
Date: Wed, 22 May 2013 20:51:26 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        "tiejun.chen" <tiejun.chen@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio device
 tree nodes
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130521174849.GL26249@lunn.ch> <519C9333.20609@gmail.com> <519C9822.9040909@windriver.com> <519C9A66.3050807@gmail.com> <20130522131010.GB31290@titan.lakedaemon.net> <20130522165908.GB12320@obsidianresearch.com> <519D0143.1000203@gmail.com> <20130522182448.GA17206@obsidianresearch.com>
In-Reply-To: <20130522182448.GA17206@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 08:24 PM, Jason Gunthorpe wrote:
> On Wed, May 22, 2013 at 07:32:51PM +0200, Sebastian Hesselbarth wrote:
>> Not neccessary anyway, after talking Jason C in a Kirkwood-only
>> workaround I prepared a patch that reads mac address registers early
>> and stores it in the local-mac-address property.
>
> That sounds great, but, FWIW, our bootloaders don't set the MAC
> address registers. Does the work around only trigger if the
> local-mac-address property is 0?

I already thought about bootloaders not setting the register, but I will
not start parsing 1001 places for a valid MAC only for those. Also
reading the MAC address registers is default behavior of mv643xx_eth if
no MAC address is passed through platform_data.

But you are right, there is plenty of sanity checks in the workaround to
ensure that local-mac-address is only overwritten by it when
- you are on DT
- there is no valid MAC address in that node (of_get_mac_address)
- there is a local-mac-address property with a length of 6 bytes

So this workaround only applies on DT booted kernels with no mac set in
DT.

Sebastian
