Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaA0NQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:16:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0NQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:16:36 -0500
Date: Mon, 27 Jan 2014 05:17:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] USB: input: gtco.c: fix usb_dev leak
Message-ID: <20140127131741.GB16027@kroah.com>
References: <1390087466-9898-1-git-send-email-khoroshilov@ispras.ru>
 <20140121195957.GB29615@core.coreip.homeip.net>
 <52E5FD48.7040208@ispras.ru>
 <20140127065416.GA11945@core.coreip.homeip.net>
 <52E63503.3060804@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E63503.3060804@ispras.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 02:29:23PM +0400, Alexey Khoroshilov wrote:
> On 27.01.2014 10:54, Dmitry Torokhov wrote:
> > Hi Alexey,
> >
> > On Mon, Jan 27, 2014 at 10:31:36AM +0400, Alexey Khoroshilov wrote:
> >> On 21.01.2014 23:59, Dmitry Torokhov wrote:
> >>> On Sun, Jan 19, 2014 at 03:24:26AM +0400, Alexey Khoroshilov wrote:
> >>>> There is usb_get_dev() in gtco_probe(), but there is no usb_put_dev()
> >>>> anywhere in the driver.
> >>>>
> >>>> The patch adds usb_get_dev() to failure handling code of gtco_probe()
> >>>> and to gtco_disconnect(().
> >>> Hmm, I think gtco should simply not use usb_get_dev() in the first
> >>> place.
> >>>
> >>> Thanks.
> >> Dear Dmitry,
> >>
> >> Could you please clarify why usb_get_dev() not needed here?
> >> We store reference to usb_dev in gtco structure, so we should refcount it.
> >> What is wrong in this reasoning?
> > The lifetime of gtco structure is already directly tied to lifetime of
> > usb_dev: when destroying usb_dev driver core will call remove() function
> > of currently bound driver (in our case gtco) which will destroy gtco
> > memory.
> >
> > Taking additional reference is not needed here.
> >
> > Hope this helps.
> Thank you, that helps a lot.
> 
> By the way, usb_skeleton suggests to use usb_get_dev()/usb_put_dev()
> nevertheless.
> 
> Greg, may be it makes sense to fix usb_skeleton as well?

Patches are always welcome.
