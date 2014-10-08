Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaJHNoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:44:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaJHNoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:44:05 -0400
Date: Wed, 8 Oct 2014 06:43:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: always assign miscdevice to file->private_data in
 open()
Message-ID: <20141008134307.GA6099@kroah.com>
References: <1412758074-7882-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412758074-7882-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 10:47:54AM +0200, Martin Kepplinger wrote:
> As of now, a miscdevice driver has to provide an implementation of
> the open() file operation if it wants to have misc_open() assign a
> pointer to struct miscdevice to file->private_data for other file
> operations to use (given the user calls open()).
> 
> This leads to situations where a miscdevice driver that doesn't need
> internal operations during open() has to implement open() that only
> returns immediately, in order to use the data in private_data in other
> fops.

Yeah, that's messy, do we have any in-kernel misc drivers that do this?

> This change provides consistent behaviour for miscdevice developers by
> always providing the pointer in private_data. A driver's open() fop would,
> of course, just overwrite it, when using private_data itself.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is really only a question: Do I understand this correctly, and,
> could this change then hurt any existing driver?

I don't know, take a look at the existing ones and see please.

> As a driver developer it took me a while to figure out what happens here,
> and in my situation it would have been nice to just have this feature as
> part of the miscdevice API. Possibly documented somewhere?

Patches always accepted for documentation :)

> misc_open() is called in any case, on open(). As long as miscdevice drivers
> don't explicitly rely on private_data being NULL exactly IF they don't
> implement an open() fop (which I wouldn't imagine), this would make things
> even more convenient.

I agree, but it would be great if you can audit the existing misc
drivers to ensure we don't break anything with this change.  Can you do
that please?

thanks,

greg k-h
