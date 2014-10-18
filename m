Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaJRWuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:50:04 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37786 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJRWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:50:03 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2014 18:50:02 EDT
Message-ID: <1413661699.19391.2.camel@linux-0dmf.site>
Subject: Re: [PATCH net] r8152: use cancel_delayed_work for runtime suspend
From: Oliver Neukum <oliver@neukum.org>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <1394712342-15778-64-Taiwan-albertk@realtek.com>
References: <1394712342-15778-64-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Oct 2014 21:48:19 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-17 at 13:55 +0800, Hayes Wang wrote:
> It would cause dead lock for runtime suspend, when the workqueue
> is running and runtime suspend occurs before the workqueue wakes
> up the device. The rtl8152_suspend() waits the workqueue to finish
> because of calling cancel_delayed_work_sync(). The workqueue waits
> the suspend function to finish for waking up the device because of
> calling usb_autopm_get_interface().

The diagnosis is good, the fix is not good. It opens a race
during which the queued work can touch a suspended device.

	Regards
		Oliver


