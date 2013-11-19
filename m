Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3KSQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:10:11 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56842 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3KSQKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:10:06 -0500
Message-ID: <1384877400.8604.107.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: RE: net/usb/ax88179_178a driver broken in linux-3.12
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Mark Lord <mlord@pobox.com>, Ming Lei <ming.lei@canonical.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Tue, 19 Nov 2013 08:10:00 -0800
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7434@saturn3.aculab.com>
References: <52890C7E.6000607@pobox.com> <52891178.2080509@pobox.com>
	 <52891341.4020403@pobox.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B742B@saturn3.aculab.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B742F@saturn3.aculab.com>
	 <528A9A36.50903@pobox.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7431@saturn3.aculab.com>
	 <528B6F73.7040801@pobox.com>
	 <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7434@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 14:43 +0000, David Laight wrote:

> It isn't directly a TSO problem.
> There has always been a bug in the xhci driver for fragmented buffers.
> TSO just means it is given a lot of fragmented buffers.
> 
> As well as user-supplied fragmented buffers, the bug affects
> internal fragmentation that happens whenever a buffer crosses a 64k
> byte boundary (please hw engineers - stop doing this!)

TCP stack uses order-3 allocations.

This means 32KB for x86 (PAGE_SIZE=4096)

What is PAGE_SIZE for your arches ?

If there is a 6KB limit, we might adapt TCP to make sure we do not cross
a 64KB boundary.

Other strategy would be to detect this case in the driver and split a
problematic segment into two parts.

> 
> I'm not sure whether usbnet would ever pass buffers that cross 64k
> boundaries. I've not seen one - even with TSO. But the rx buffers
> are 20k (doesn't seem ideal!) and could also be problematical.
> 
> USB mass storage has used SG for ages, the buffers must all be
> adequately aligned for the hardware - they won't meet the constraint
> for USB3 itself, but the documented restriction may be more severe
> than the actual one.


