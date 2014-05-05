Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaEENzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:55:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbaEENzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:55:10 -0400
Date: Mon, 5 May 2014 15:55:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Bayer <thematthiasbayer@gmail.com>
Subject: Re: [PATCH] HID: core: fix computation of the report size
In-Reply-To: <1398894520-30407-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1405051554530.3969@pobox.suse.cz>
References: <1398894520-30407-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014, Benjamin Tissoires wrote:

> The extra seven bits are only required when allocating the report buffer.
> We can not use those extra bytes for the length of the report in the
> generic implementation of .request because the device might (will) refuse
> the set_report command.
> This has been verified on the Atmel touchpad found on the Samsung Ativ 9
> plus, which uses hid-multitouch and HID over I2C. Without this fix, the
> device refuses to switch to the multitouch mode, and it becomes unresponsive
> from the user point of view.
> 
> Actually, this has been discussed during the initial submission of the
> commit 4fa5a7f76cc7b6ac87f57741edd2b124851d119f, see
> https://patchwork.kernel.org/patch/3621751/
> 
> Unfortunately, I completely forgot about it later.
> 
> Reported-by: Matthias Bayer <thematthiasbayer@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> can you schedule this fix for 3.15?
> 
> Fortunately, the device required some ACPI changes, so it was not seen at all
> in 3.13 and before. I am not sure of the status of 3.14, but it is definitively
> not working in 3.15.

Gah, indeed, a nasty bug.

Queuing for 3.15 now, thanks!

-- 
Jiri Kosina
SUSE Labs
