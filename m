Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaAGDw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:52:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbaAGDw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:52:57 -0500
Date: Mon, 6 Jan 2014 19:53:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?5rKI5YWJ?= <shenguang10@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
Message-ID: <20140107035312.GA13379@kroah.com>
References: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
 <20140107024050.GA8903@kroah.com>
 <CANthSfb+t53BZSXGe2VUUuHRYzphuT=-3vJtCSoERF_WChUr-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANthSfb+t53BZSXGe2VUUuHRYzphuT=-3vJtCSoERF_WChUr-A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:35:50AM +0800, 沈光 wrote:
> On Tue, Jan 7, 2014 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jan 07, 2014 at 10:33:14AM +0800, 沈光 wrote:
> >> set hub->change_bits when we plug in a device which causes
> >> over-current condition, so that hub_events() will check it.
> >
> > Why?
> >
> > What does this solve?  Is this a bug with existing devices that needs to
> > be backported to older kernels?
> >
> > thanks,
> >
> > greg k-h
> 
> This is something that we found when we are doing compliance test with xHCI.
> If we enable CONFIG_USB_SUSPEND, and plug in a bad device which causes
> over-current condition to the root port, the hub->change_bits will not
> be set in current code in the function of hub_activate.

Now that's something that should go in the changelog, don't you think?

thanks,

greg k-h
