Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3A1KbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:31:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:21583 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3A1KbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="249144882"
Date: Mon, 28 Jan 2013 02:06:03 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] dmaengine: add per channel capabilities api
Message-ID: <20130128100603.GP26562@intel.com>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <abcd725c6216491da2b1054e5e11ad82@DFLE72.ent.ti.com>
 <20130120163735.GC21407@beef>
 <c4113bae604945b586e9613814be737a@DLEE74.ent.ti.com>
 <20130121181922.GD10020@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121181922.GD10020@beef>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:19:23PM -0500, Matt Porter wrote:
> > b) Sg segment length and numbers: Well these are capabilities, so it tells
> > you what is the maximum I can do. IMO it doesn't make sense to tie it down to
> > burst, width etc. For that configuration you are checking maximum. What this
> > needs to return is what is the maximum length it supports and maximum number of
> > sg list the h/w can use. Also if you return your burst and width capablity, then
> > any client can easily find out what is the length byte value it can hold.
>  
> Ok, so I could report the max burst size to the client, but on EDMA it's
> going to be SZ_64K-1, as that's the hw limit. Max addr width would also
> be the same or capped at the maximum enum the current API support of 8
> bytes.
Yes IMO you should report the h/w limit and let client deduce what can be done
with that h/w limit given the other parameters (burst, length etc...)
> 
> This information is not useful to the client in my case. Only the client
> knows its FIFO size, and thus the actual burst size it needs to request
> as that is a value specific to the IP the client driver controls. So it
> knows actual burst size and the width of that fifo transfer, because we
> already support telling the dmaengine driver this info in the current
> API.
Your current API way is not very generic. We need to make sure it useful on
other systems too. That is why it would make sense to query the DMA H/W
capablities and then use it with above properties to get various parameters used
for initiating a transfer, that way you dont need to set slave parameters

--
~Vinod
