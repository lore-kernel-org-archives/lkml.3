Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3LHP0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:26:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3LHP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:26:05 -0500
Date: Sun, 8 Dec 2013 07:27:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix device_create() error path
Message-ID: <20131208152737.GB26218@kroah.com>
References: <1385061348-13153-1-git-send-email-dh.herrmann@gmail.com>
 <CANq1E4TcjmcPbj2GvgUcXA7_+AaevbMTC6+2CsbrugJjjC755A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4TcjmcPbj2GvgUcXA7_+AaevbMTC6+2CsbrugJjjC755A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 03:42:33PM +0100, David Herrmann wrote:
> Hi Greg
> 
> Ping?

It's in my "todo" queue, don't worry, it's not lost.

> On Thu, Nov 21, 2013 at 8:15 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> > We call put_device() in the error path, which is fine for dev==NULL.
> > However, in case kobject_set_name_vargs() fails, we have dev!=NULL but
> > device_initialized() wasn't called, yet.

If kobject_set_name_vargs() fails, we have bigger problems than this :)

And I think it's safe for a put_device() on a device that wasn't
initialized(), we just get a warning message if that happens.

Not to say that your patch is wrong, I'll look at it soon, but things
should still recover ok from what I can tell.

Oh, and there's the much-complained about memory leak in
kobject_set_name_vargs() if something goes wrong there as well, I have a
patch sitting in my queue to hopefully fix that up.

thanks,

greg k-h
