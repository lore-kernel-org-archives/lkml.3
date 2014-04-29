Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbaD2RG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:06:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:61244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbaD2RGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,952,1389772800"; 
   d="scan'208";a="425490888"
Message-ID: <535FDE71.7000601@linux.intel.com>
Date: Tue, 29 Apr 2014 20:16:33 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
References: <CAODwPW9i-pwgzE-OELwwkw2M_Vnhtsq4p=_5ppO7R6xXpzu==w@mail.gmail.com>	<Pine.LNX.4.44L0.1404011753420.8643-100000@netrider.rowland.org> <CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
In-Reply-To: <CAODwPW_N9sNKCcfD9ebGgCW71+zN_Ge9OM9uq7eRwyxgfyu4Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:11 AM, Julius Werner wrote:
> *bump*
>
> Sarah, Mathias, can we decide how to proceed with this? I think the
> section Alan quoted is a pretty good argument in favor of my
> interpretation (although of course this would not be the first time
> that two sections of a spec contradict each other). But more
> importantly, we have a case that just generates a clearly wrong Slot
> Context right now (the one that only drops endpoints), and I see no
> way how you could construct a correct Slot Context for that case with
> Sarah's interpretation. We need to resolve that somehow.

We discussed with Sarah that we should try this out and queue it for 
usb-linus. This clearly fixes the generation of a invalid slot context 
if all endpoints are dropped.

But because there hasn't been any reported issue about the other case 
this changes (always setting context entries to last valid ep in target 
configuration), and spec still has this tiny contradiction in this case, 
we should keep this out of stable. At least for now, until it gets some 
real world testing coverage.

-Mathias


