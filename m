Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894Ab3E3ERP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:17:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38654 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3E3ERM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:17:12 -0400
Message-ID: <51A6D2A2.30302@ahsoftware.de>
Date: Thu, 30 May 2013 06:16:34 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename ambiguous named XHCI_NEC_HOST to
 XHCI_NEC_SHOW_FW
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de> <20130529222500.GC7151@xanatos>
In-Reply-To: <20130529222500.GC7151@xanatos>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.05.2013 00:25, schrieb Sarah Sharp:
> 
> On Wed, May 29, 2013 at 11:14:32PM +0200, Alexander Holler wrote:
>> Current Renesas Electronics XHCI hosts (which were formerly NEC)
>> do support the same vendor command to show the firmware. Rename the
>> ambigious named define XHCI_NEC_HOST to XHCI_NEC_SHOW_FW because it's
>> only used to display the firmware version. Besides that, change the
>> output "... NEC firmware version x.y" to "... firmware version x.y"
>> to not confuse owners of Renesas USB hosts.
>>
>> (so only cosmetic, no functional changes)
> 
> I'm actually inclined to say you should just rip out the firmware
> version code entirely.  I haven't needed to use it for years, and if
> Renesas changed their vendor command set, I would rather not submit
> random commands to the host.
> 
> So, can you redo this patch to just rip out XHCI_NEC_HOST and everything
> that uses it?

Hmm, I find the firmware version rather informational and would even
display it unconditionally (instead of with xhci_debug). It prevents the
need to boot Windows to checkout if the latest version is installed,
especially if someone is hunting a bug.

I just dont't like the name, because e.g. in my case, it made me to have
a deeper look at what that quirk does, because I had the hope it might
solve a problem. Therefor I think it's useful to rename it.

Regards,

Alexander Holler

