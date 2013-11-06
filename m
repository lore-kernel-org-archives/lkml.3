Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab3KFUnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:43:09 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62547 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3KFUnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:43:07 -0500
Date: Wed, 6 Nov 2013 12:45:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
Message-ID: <20131106204523.GA19041@kroah.com>
References: <1383769641-22910-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383769641-22910-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:27:21PM -0800, Julius Werner wrote:
> This patch adds a check for USB_STATE_NOTATTACHED to the
> hub_port_warm_reset_required() workaround for ports that end up in
> Compliance Mode in hub_events() when trying to decide which reset
> function to use. Trying to call usb_reset_device() with a NOTATTACHED
> device will just fail and leave the port broken.

Who makes those calls, drivers?  Any specific ones that you know need to
be fixed?

> Also bumped the messages about this kind of reset failure from dev_dbg()
> to dev_warn() to make it easier to notice, since calling that function
> with a NOTATTACHED device would almost always be a bug

But what can a user do if those messages show up?

thanks,

greg k-h
