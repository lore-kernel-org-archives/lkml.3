Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966542Ab3DRQUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:20:03 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43609 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965490Ab3DRQUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:20:01 -0400
Message-ID: <51701D2E.6060903@console-pimps.org>
Date: Thu, 18 Apr 2013 17:19:58 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Darren Hart <darren.hart@intel.com>
CC: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com>
In-Reply-To: <51700876.1000305@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/04/13 15:51, Darren Hart wrote:
> I don't believe I have seen a 32-bit EFI system with a BGRT, but then
> again, I had to look it up today! That said, I suspect the MinnowBoard
> would benefit from such a thing, so we should have an example of it
> there in the near future.
 
That's fine and things will work as-is provided that the BGRT image is
not in highmem.

> Is this in anyway related to the following patch from Josh Boyer? We're
> carrying this in the Yocto Project trees currently.
> 
>      commit 6f3e186bc7721c5b24ad90d4a751cccfccd445e6
>      Author: Josh Boyer <jwboyer@redhat.com>
>      Date:   Fri Aug 5 08:47:23 2011 -0400
> 
>         Add patch to fix 32bit EFI service mapping (rhbz 726701)
> 
>     Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
>     Signed-off-by: Darren Hart <dvhart@linux.intel.com>

Yep, it's basically the same fix. My patch just avoids the #ifdef and
prints an error message if we have EFI Boot services regions we can't
access directly. The error message will at least be useful if we do
start seeing BGRT pointers in highmem.

Could you give it a spin on your MinnowBoard?

-- 
Matt Fleming, Intel Open Source Technology Center
