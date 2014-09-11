Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaIKVhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaIKVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:37:42 -0400
Date: Thu, 11 Sep 2014 14:37:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Message-ID: <20140911213741.GA4542@kroah.com>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F9872E@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F9872E@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:57:34PM +0000, Hartley Sweeten wrote:
> On Tuesday, September 09, 2014 3:26 AM, Ian Abbott wrote:
> > The `comedi_board` inline function takes a single parameter of type
> > `struct comedi_device *` and merely returns the value of the `board_ptr`
> > member therein.  This is somewhat superfluous as the member can be
> > accessed directly.
> >
> > Replace all uses of `comedi_board(dev)` with `dev->board_ptr`.
> >
> > Note, if there are any conflicts when applying this series, they can
> > just be skipped for now and corrected later.
> >
> > A subsequent patch will remove the `comedi_board` function, once there
> > is nothing using it.
> 
> Greg,
> 
> Just wanted to give you a heads up on this series and the ones I have
> posted. The series are:
> 
> >From Ian, [PATCH 00/48] staging: comedi: avoid using comedi_board()
> >From me, [PATCH 00/30] staging: comedi: adl_pci9118: continue cleanup
> >From me, [PATCH 00/34] staging: comedi: cleanup async cmd->stop_{src,arg} usage
> 
> There are a couple conflicts between the series from Ian and my two.
> If you drop these two from Ian's series:
>  
> 06) staging: comedi: adl_pci9118: replace comedi_board() calls
> 10) staging: comedi: amplc_dio200_common: replace comedi_board() calls
> 
> The rest will apply cleanly in the order above (assuming I didn't miss anything).

I applied all of the above, with the 2 patches from Ian going last and
git handling the merge issues.

> Also, Ian had a couple issues with patch 07/34 and 08/34 from the last
> series I posted. I already asked if you could drop those two. I needed I
> will repost the series.

I've dropped them.  Hopefully I got it all right, it should all be
pushed out now, verifying this would be good :)

thanks,

greg k-h
