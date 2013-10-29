Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3J2VIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:08:02 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:37139 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3J2VIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:08:00 -0400
Date: Tue, 29 Oct 2013 22:07:58 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: 3.12-rc7 regression - network panic from ipv6
Message-ID: <20131029210758.GA18323@order.stressinduktion.org>
Mail-Followup-To: Meelis Roos <mroos@linux.ee>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, steffen.klassert@secunet.com
References: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:33:36PM +0200, Meelis Roos wrote:
> Some bad news - in a system where 3.12-rc6 and earlier worked fine, 
> 3.12-rc7 panics or hangs repeatedly with network traffic (torrent being 
> good test). First there is BUG from ipv6 code, followed by panic.

Could you do a bisect on this? There seems to be one commit for this
particular function _decode_session6:

commit bafd4bd4dcfa13145db7f951251eef3e10f8c278
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Mon Sep 9 10:38:38 2013 +0200

    xfrm: Decode sessions with output interface.
    
    The output interface matching does not work on forward
    policy lookups, the output interface of the flowi is
    always 0. Fix this by setting the output interface when
    we decode the session.

Maybe try to just revert this change locally and try again?

Thanks,

  Hannes

