Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJEXY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:24:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJEXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:24:58 -0400
Date: Sun, 5 Oct 2014 16:24:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Noakes <jjnoakes@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kobject_init and the zeroed-out-memory requirement
Message-ID: <20141005232457.GA22525@kroah.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
 <20141005202843.GA1282@kroah.com>
 <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com>
 <20141005215100.GA20426@kroah.com>
 <CAN2+FEKvNz1eCUyThPs3qoX+uG__KzTu67egnu-pz7hxmM9Jjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN2+FEKvNz1eCUyThPs3qoX+uG__KzTu67egnu-pz7hxmM9Jjw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 06:13:05PM -0400, Jason Noakes wrote:
> > No driver should be working with "raw" kobjects.
> 
> I don't agree, but it's irrelevant.

Not at all.  I'd wager that if a driver is messing around with a "raw"
kobject, it is doing something seriously wrong.  Of course there are
exceptions, but those are very rare, and exceptions.  A driver should be
using the driver core, and the functions and objects provided there, and
provided by the bus it lives on.

So, have a pointer to some driver code that is calling
kobject_initialize()?  I'd love to see it.

thanks,

greg k-h
