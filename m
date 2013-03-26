Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab3CZQNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:13:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41248 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933979Ab3CZQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:13:03 -0400
X-Sasl-enc: BsFyBRKFw4tR2K6bhmOo9hraS02o/GFVlbUAO7x7NmOZ 1364314380
Message-ID: <5151C90A.5010108@ladisch.de>
Date: Tue, 26 Mar 2013 17:12:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> Quadlet reads to memory above 4GB is painfully slow when serviced
> by the AR DMA context. In addition, the CPU(s) may be locked-up,
> preventing any transfer at all.

Using physical DMA prevents the use of that address space for software
address handlers, so you have adjust the low_memory_region start in
core-transaction.c.

> Write the PhyUpperBound register with the end-of-memory value. If
> end-of-memory is beyond the OHCI limit of 0x0000ffff00000000,
> clamp to that value.

You will have to lower this limit; there are protcols that assume that
addresses like 0xecc000000000 are available for software.


Regards,
Clemens
