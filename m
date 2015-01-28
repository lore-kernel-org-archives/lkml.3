Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbbA2BwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbbA2BwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:21 -0500
Date: Wed, 28 Jan 2015 13:05:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add device_create_files() and device_remove_files()
 helpers
Message-ID: <20150128210547.GA18649@kroah.com>
References: <1422477974-8369-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422477974-8369-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:46:12PM +0100, Takashi Iwai wrote:
> Hi,
> 
> this is a simple patch to add device_create_files() and
> device_remove_files() to replace multiple device_create_file() or
> _remove() calls with a single shot with the device_attr list.
> 
> It's basically just a clean up, but also helps to simplify the error
> handling a lot in many existing codes since the function itself does
> rollback at error.
> 
> The series contains a patch to apply these to drivers/base/node.c.
> I have lots of patches (up to 30) to use these in the whole tree, but
> maybe it'd be easier too apply once after this stuff is merged at
> first.  It's just a cleanup so no urgent task, after all.

I'd like to some day be able to drop device_create_file entirely, as it
is almost always used in a racy way (but not always, so we can't get rid
of it today.)

A driver should be using an attribute group and be created/registered
with it if they want any files associated with it, so giving people the
ability to add large numbers of files all at once seems like the wrong
thing to do :)

thanks,

greg k-h
