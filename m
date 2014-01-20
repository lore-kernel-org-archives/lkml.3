Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaATWMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:12:38 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27493 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaATWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:12:35 -0500
X-IronPort-AV: E=Sophos;i="4.95,692,1384300800"; 
   d="scan'208";a="92610713"
Date: Mon, 20 Jan 2014 22:12:33 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 8/9] xen-netback: Timeout packets in RX path
Message-ID: <20140120221233.GB5058@zion.uk.xensource.com>
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
 <1390253069-25507-9-git-send-email-zoltan.kiss@citrix.com>
 <20140120220348.GA5058@zion.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140120220348.GA5058@zion.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 10:03:48PM +0000, Wei Liu wrote:
[...]
> 
> You beat me to this. Was about to reply to your other email. :-)
> 
> It's also worth mentioning that DIV_ROUND_UP part is merely estimation,
> as you cannot possible know the maximum / miminum queue length of all
> other vifs (as they can be changed during runtime). In practice most
> users will stick with the default, but some advanced users might want to
> tune this value for individual vif (whether that's a good idea or not is
> another topic).
> 
> So, in order to convince myself this is safe. I also did some analysis
> on the impact of having queue length other than default value.  If
> queue_len < XENVIF_QUEUE_LENGTH, that means you can queue less packets
> in qdisc than default and drain it faster than calculated, which is
> safe. On the other hand if queue_len > XENVIF_QUEUE_LENGTH, it means
> actually you need more time than calculated. I'm in two minded here. The
> default value seems sensible to me but I'm still a bit worried about the
> queue_len > XENVIF_QUEUE_LENGTH case.
> 
> An idea is to book-keep maximum tx queue len among all vifs and use that
> to calculate worst scenario.
> 

And unfortunately there doesn't seem to be a way to know when tx queue
length is changed! So this approach won't work. :-(

Wei.
