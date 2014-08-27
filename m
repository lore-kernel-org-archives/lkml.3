Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbaH0OLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:11:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:50028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934604AbaH0OLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,411,1406617200"; 
   d="scan'208";a="564161981"
Message-ID: <53FDEA48.9030301@intel.com>
Date: Wed, 27 Aug 2014 17:25:12 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 06:47 PM, Ricardo Ribalda Delgado wrote:
> While testing a usb gadget I managed to crash completely the host
> computer. This was due to a NULL pointer derefence.
> 
> This patch avoids the crash although the kernel still outputs some
> warnings.
> 
> Without this patch, kernels from (at least) 3.14 can be crashed with
> mass storage gadgets.
> 
> Affected host:  NEC Corporation uPD720200 USB 3.0
> 


This should not be necessary anymore after 
commit 365038d83313951d6ace15342eb24624bbef1666
    xhci: rework cycle bit checking for new dequeue pointers

http://marc.info/?l=linux-usb&m=140844993115671&w=2

Which was just added to Greg's usb-linus branch.
It checks that the new_deq_ptr and new_deq_seg are valid before calling
xhci_queue_new_dequeue_state()

-Mathias





