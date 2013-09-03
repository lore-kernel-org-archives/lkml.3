Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab3ICVX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:23:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3ICVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:23:56 -0400
Date: Tue, 3 Sep 2013 14:23:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yhchen@faraday-tech.com
Subject: Re: usb: host: Faraday fotg210-hcd driver
Message-ID: <20130903212355.GA12978@kroah.com>
References: <20130903185912.A59316601F4@gitolite.kernel.org>
 <20130903211544.GB2247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903211544.GB2247@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:15:44PM -0400, Dave Jones wrote:
> On Tue, Sep 03, 2013 at 06:59:12PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1dd3d123239179fad5de5dc00a6e0014a1918fde
>  > Commit:     1dd3d123239179fad5de5dc00a6e0014a1918fde
>  > Parent:     10e232c597ac757e7f8600649f7e872e86de190f
>  > Author:     Yuan-Hsin Chen <yhchen@faraday-tech.com>
>  > AuthorDate: Wed Jun 19 19:53:04 2013 +0000
>  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  > CommitDate: Wed Jul 24 16:04:53 2013 -0700
>  > 
>  >     usb: host: Faraday fotg210-hcd driver
>  >     
>  >     FOTG210 is an OTG controller which can be configured as an
>  >     USB2.0 host. FOTG210 host is an ehci-like controller with
>  >     some differences. First, register layout of FOTG210 is
>  >     incompatible with EHCI. Furthermore, FOTG210 is lack of
>  >     siTDs which means iTDs are used for both HS and FS ISO
>  >     transfer.
>  >     
>  >     Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>  >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  > +config USB_FOTG210_HCD
>  > +	tristate "FOTG210 HCD support"
>  > +	depends on USB
>  > +	default N
>  > +	---help---
>  > +	  Faraday FOTG210 is an OTG controller which can be configured as
>  > +	  an USB2.0 host. It is designed to meet USB2.0 EHCI specification
>  > +	  with minor modification.
>  > +
>  > +	  To compile this driver as a module, choose M here: the
>  > +	  module will be called fotg210-hcd.
>  > +
> 
> Shouldn't this depend on USB_OTG ?
> Seems odd to have OTG related options presented to me when I have that unset.

It's a USB Host controller, so it should be built if you have that
option set.  The fact that it can do OTG isn't an issue here, from what
I can tell.

thanks,

greg k-h
