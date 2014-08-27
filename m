Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaH0JUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:20:14 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62451 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaH0JUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:20:11 -0400
Date: Wed, 27 Aug 2014 10:20:02 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 0/4] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Message-ID: <20140827092002.GA1827@sucs.org>
References: <1409079922-16560-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409079922-16560-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 12:05:22PM -0700, K. Y. Srinivasan wrote:
> Cleanup the channel management code and eliminate calls to BUG_ON()
> 
> K. Y. Srinivasan (4):
>   Drivers: hv: vmbus: Cleanup vmbus_post_msg()
>   Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
>   Drivers: hv: vmbus: Cleanup vmbus_close_internal()
>   Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()

I've applied these on top of 3.17-rc1 and my Hyper-V guest with most
verification on bar DEBUG_PAGEALLOC boots without issue so long as I
have more than one CPU assigned (that issue is being investigated in
https://lkml.org/lkml/2014/8/26/271, [PANIC, hyperv] BUG: unable to
handle kernel paging request at ffff880077800004 (hv_ringbuffer_write)).

With DEBUG_PAGEALLOC on I hit https://lkml.org/lkml/2014/8/19/227 (BUG:
unable to handle kernel paging request at ffff8801f3febe63
(netvsc_select_queue)) but that's different to the above BUG_ONs.

-- 
Sitsofe | http://sucs.org/~sits/
