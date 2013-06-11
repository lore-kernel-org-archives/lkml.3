Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3FKHW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:22:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35739 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab3FKHWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:22:25 -0400
Date: Tue, 11 Jun 2013 08:22:22 +0100
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Zach Bobroff <zacharyb@ami.com>, stable@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Message-ID: <20130611072222.GH31198@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun, at 07:52:38AM, Matt Fleming wrote:
> From: Zach Bobroff <zacharyb@ami.com>
> 
> ExitBootServices is absolutely supposed to return a failure if any
> ExitBootServices event handler changes the memory map.  Basically the
> get_map loop should run again if ExitBootServices returns an error the
> first time.  I would say it would be fair that if ExitBootServices gives
> an error the second time then Linux would be fine in returning control
> back to BIOS.
> 
> The second change is the following line:
> 
> again:
>         size += sizeof(*mem_map) * 2;
> 
> Originally you were incrementing it by the size of one memory map entry.
> The issue here is all related to the low_alloc routine you are using.
> In this routine you are making allocations to get the memory map itself.
> Doing this allocation or allocations can affect the memory map by more
> than one record.
> 
> [ mfleming - changelog, code style ]
> Signed-off-by: Zach Bobroff <zacharyb@ami.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

I've queued this patch up for v3.11 in my 'next' branch.

-- 
Matt Fleming, Intel Open Source Technology Center
