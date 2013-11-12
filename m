Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3KLAHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:07:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:55710 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3KLAHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:07:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407148091"
Message-ID: <52817251.3040509@linux.intel.com>
Date: Mon, 11 Nov 2013 16:12:01 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5.1 4/5] check quirk to pad epout buf size when not aligned
 to maxpacketsize
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com> <xa1ttxfiwkw0.fsf@mina86.com>
In-Reply-To: <xa1ttxfiwkw0.fsf@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 11/11/2013 03:58 PM, Michal Nazarewicz wrote:
> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> to pad epout buffer to match above condition if quirk is found.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/usb/gadget/f_fs.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> On Tue, Nov 12 2013, David Cohen wrote:
>> One curiosity here. This patch prints the following warning:
>>
>> In file included from (...)/drivers/usb/gadget/g_ffs.c:55:0:
>> (...)/drivers/usb/gadget/f_fs.c: In function 'ffs_epfile_io.isra.18':
>> (...)/drivers/usb/gadget/f_fs.c:837:15: warning: 'data_len' may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
>
> With the below code, this should no longer be a problem.
>
> Also fixes issues pointed out by Alan.

You need to update req->length otherwise it's going to crash DWC3.
I'd rather to keep your previous version.

Br, David
