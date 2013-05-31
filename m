Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3EaAVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:21:21 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38027 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3EaAVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:21:10 -0400
Message-ID: <51A7ECD9.5080705@ahsoftware.de>
Date: Fri, 31 May 2013 02:20:41 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename ambiguous named XHCI_NEC_HOST to
 XHCI_NEC_SHOW_FW
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de> <20130529222500.GC7151@xanatos> <51A6D2A2.30302@ahsoftware.de> <20130530182009.GB8006@xanatos>
In-Reply-To: <20130530182009.GB8006@xanatos>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.05.2013 20:20, schrieb Sarah Sharp:
> On Thu, May 30, 2013 at 06:16:34AM +0200, Alexander Holler wrote:

> The point is that unless Renesas tells us how to know if a host
> supports the firmware fetch vendor command, we should stop issuing that
> command to the host.  I think my contacts at Renesas have moved onto
> other jobs, but maybe you know someone there?

No, sorry.

>> I just dont't like the name, because e.g. in my case, it made me to have
>> a deeper look at what that quirk does, because I had the hope it might
>> solve a problem. Therefor I think it's useful to rename it.
> 
> I understand.  If the command worked fine on all Renesas hosts, I would
> be fine with renaming it and printing it with dev_info instead of
> xhci_dbg.  However, since some Renesas hosts don't support the command,
> I'm concerned we may be forced to rip out the code.  If you don't do it,
> I will have to.

I don't want to do it as it works fine on my Renesas upd720202.

Instead of removing this feature completely, you could just use the
first patch and forget the second one. So only NEC hosts will still have
it and I assume there will not any new appear, as they are now Renesas.

Another possibility would be to use the device ID too (for Renesas
devices), mine has 0x0015.

The reason why I really like this feature is that there were already 2-3
firmware updates and since USB 3.0 still isn't that widely used, I
assume more will appear if more people actually start using such devices.

Regards,

Alexander Holler
