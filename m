Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3CRXIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:08:09 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34682 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3CRXIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:08:07 -0400
Date: Mon, 18 Mar 2013 16:09:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: Make USB persist default configurable
Message-ID: <20130318230922.GA23175@kroah.com>
References: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 03:57:31PM -0700, Julius Werner wrote:
> Commit 9214d1d8 set the USB persist flag as a default for all devices.
> This might be desirable for some distributions, but it certainly has its
> trade-offs... most importantly, it can significantly increase system
> resume time, because the kernel blocks on resuming (and sometimes
> resetting) USB devices before it unfreezes userspace.
> 
> This patch introduces a new config option CONFIG_USB_DEFAULT_PERSIST,
> which allows distributions to make this decision on their own without
> the need to carry a custom patch or revert the kernel's setting in
> userspace.

Why can't you just revert this in userspace?  Isn't that easier than
doing a kernel patch and providing an option that we need to now
maintain for pretty much forever?

thanks,

greg k-h
