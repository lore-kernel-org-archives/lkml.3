Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaHDPe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:34:26 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21671 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaHDPeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:34:24 -0400
X-IronPort-AV: E=Sophos;i="5.01,799,1400025600"; 
   d="scan'208";a="158537889"
Message-ID: <53DFA7FE.3000507@citrix.com>
Date: Mon, 4 Aug 2014 16:34:22 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier handling
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 16:20, Zoltan Kiss wrote:
> This series starts using carrier off as a way to purge packets when the guest is
> not able (or willing) to receive them. It is a much faster way to get rid of
> packets waiting for an overwhelmed guest.
> The first patch changes current netback code where it relies currently on
> netif_carrier_ok.
> The second turns off the carrier if the guest times out on a queue, and only
> turn it on again if that queue (or queues) resurrects.
>
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
>

Sorry, I forgot to include v2 in the subject header, and the version 
history for the second patch:

v2:
- added a lot more comments
- fixing the bit checking in RX interrupt
- move out the bulk of the code from the main thread function into
   xenvif_rx_purge_event

Zoli
