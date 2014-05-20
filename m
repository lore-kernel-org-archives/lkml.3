Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaETA6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:58:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaETA6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:58:33 -0400
Date: Tue, 20 May 2014 09:58:31 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a
 vmalloc'd transfer buffer
Message-ID: <20140520005831.GA7933@kroah.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
 <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
 <CAPcyv4hzw4wQ2ju3uaaHNfO+pemgWhgVdkE1Faiu3nRk3q276A@mail.gmail.com>
 <5370E22E.8000304@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5370E22E.8000304@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 06:01:02PM +0300, Mathias Nyman wrote:
> On 05/08/2014 07:21 PM, Dan Williams wrote:
> > On Thu, May 8, 2014 at 9:25 AM, Mathias Nyman
> > <mathias.nyman@linux.intel.com> wrote:
> >> From: Dan Williams <dan.j.williams@intel.com>
> >>
> >> Save someone else the debug cycles of figuring out why a driver's
> >> transfer request is failing or causing undefined system behavior.
> >> Buffers submitted for dma must come from GFP allocated / DMA-able
> >> memory.
> >>
> >> Return -EAGAIN matching the return value for dma_mapping_error() cases.
> >>
> >> Cc: Alan Stern <stern@rowland.harvard.edu>
> >> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> >> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> >
> > Thanks Mathias.
> >
> > One note, this was acked-by Alan here:
> >
> > http://marc.info/?l=linux-usb&m=139327920501989&w=2
> >
> 
> Ah, Right
> 
> Greg, Alan, Should I resubmit this series with the added ACK for this patch?

No need, I can add it.
