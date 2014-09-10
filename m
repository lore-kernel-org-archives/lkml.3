Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaIJLdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:33:10 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54796 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaIJLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:33:07 -0400
Message-ID: <541036F0.2030001@mojatatu.com>
Date: Wed, 10 Sep 2014 07:33:04 -0400
From: Jamal Hadi Salim <jhs@mojatatu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org, sandeep_n@ti.com,
        Benjamin LaHaise <bcrl@kvack.org>,
        shrijeet Mukherjee <shm@cumulusnetworks.com>
Subject: Re: [PATCH v2 0/3] net: Add Keystone NetCP ethernet driver support
References: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com> <20140821.163612.282672926741753926.davem@davemloft.net> <53F79DC5.8030003@ti.com> <540DC00F.1080103@ti.com> <540EE809.9020901@mojatatu.com> <540F1A9A.1020309@ti.com>
In-Reply-To: <540F1A9A.1020309@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 11:19, Santosh Shilimkar wrote:

> All the documentation is open including packet accelerator offload
> in ti.com.

Very nice.
Would you do me a kindness and point to the switch interface
documentation (and other ones on that soc)?

> We got such requests from customers but couldn't
> support it for Linux.

It has been difficult because every chip vendor is trying
to do their own thing. Some have huge (fugly) SDKs in user space
which make it worse. Thats the struggle we are trying to
deal with. Of course none of those vendors want to open
up their specs. You present a nice opportunity to not follow
that path.

> We are also looking for such
> support and any direction are welcome. Your slide
> deck seems to capture the key topics like L2/IPSEC
> offload which we are also interested to hear.
>

The slides list the most popular offloads. But not necessarily
all known offloads.

> Just to be clear, your point was about L2 switch offload
> which the driver don't support at the moment. It might confuse
> others. The driver doesn't implements anything non-standard.
>

If i understood you correctly:
Your initial patches dont intend to expose any offloads - you are just
abstracting this as a NIC. I think that is a legit reason.
However, the problem is you are also exposing the packet processors
and switch offloading in a proprietary way.
For a sample of how L2 basic functions like FDB tables are controlled
within a NIC - take a look at the Intel NICs.
Either that or you hide all the offload interfaces and over time add
them (starting with L2 - NICs with L2 are common).

cheers,
jamal
