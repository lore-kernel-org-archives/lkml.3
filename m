Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3HTOO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:14:26 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59818 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3HTOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:14:25 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Manoj Chourasia <mchourasia@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hidraw: correctly deallocate memory on device disconnect
Date: Tue, 20 Aug 2013 16:14:21 +0200
Message-ID: <1707995.vN5QlUzrT9@al>
User-Agent: KMail/4.11 (Linux/3.11.0-1-custom; KDE/4.11.0; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1308091130420.13089@pobox.suse.cz>
References: <F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47@BGMAIL02.nvidia.com> <alpine.LNX.2.00.1308091130420.13089@pobox.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 August 2013 11:31:15 Jiri Kosina wrote:
> On Mon, 22 Jul 2013, Manoj Chourasia wrote:
> > This is mail is in regard to your commit for hidaw devices. We were
> > seeing kernel crashes while connect and disconnect a hidraw device and
> > we were hitting rb tree corruption in vmalloc and kernel was crashing
> > because of null pointer de-reference. Later we figure out that was
> > because the hid device disconnect is freeing memory which later got
> > access by hidraw_read and hid_write.
> 
> Now applied, thanks Manoj, thanks Peter.

I just noticed an issue with this patch, after playing with some receivers I 
saw 8 hidraw device nodes. Every USB receiver creates two hidraw nodes, one 
for the receiver and one for the paired device.

UPower seems to keep the file descriptor open which prevents the hidraw device 
from being removed. Shouldn't the implementation of hidraw be changed to 
separate open file descriptors from the actual HID devices? That should allow 
/dev/hidrawX devices to get removed whenever a HID device is gone.

Regards,
Peter
