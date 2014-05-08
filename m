Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaEHQVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:21:55 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60312 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaEHQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
	<1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
Date: Thu, 8 May 2014 09:21:51 -0700
Message-ID: <CAPcyv4hzw4wQ2ju3uaaHNfO+pemgWhgVdkE1Faiu3nRk3q276A@mail.gmail.com>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a vmalloc'd
 transfer buffer
From: Dan Williams <dan.j.williams@intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 9:25 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> From: Dan Williams <dan.j.williams@intel.com>
>
> Save someone else the debug cycles of figuring out why a driver's
> transfer request is failing or causing undefined system behavior.
> Buffers submitted for dma must come from GFP allocated / DMA-able
> memory.
>
> Return -EAGAIN matching the return value for dma_mapping_error() cases.
>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Thanks Mathias.

One note, this was acked-by Alan here:

http://marc.info/?l=linux-usb&m=139327920501989&w=2
