Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3HVApQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:45:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:60106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab3HVApP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="391270470"
Date: Wed, 21 Aug 2013 17:45:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        mathias.nyman@linux.intel.com
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130822004514.GB19747@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 02:43:55PM -0700, Julius Werner wrote:
> > Thanks for the patch!  Did you test with a USB analyzer to see if the
> > device was actually going into USB 2.0 Link PM?  I'd like to confirm we
> > really aren't breaking anything for DW3 hosts by enabling this.
> 
> Yes, I did. The LPM transfers on the analyzer look good and the device
> works as expected.

Ok, good to know.  Greg, is your USB tree still open for feature
requests?  I wouldn't normally send you usb-next requests so late, but
this is pretty simple patch to extend a feature that's already in your
usb-next tree.

> My platform only runs a 3.8 derivative, though, so I now have also
> cherry-picked the BESL patches that went in since then to make sure
> they don't break things. I had problems on one device until I found
> the XHCI_BLC fix Mathias sent out this morning, so you should pick
> that one up first. (Without it LPM doesn't break completely but seems
> to assert resume for less time than the HIRD defines, so the device
> sometimes gets confused and resets. I can't figure out how BESL is
> really supposed to work since the XHCI spec from 8/14/12 where it's
> supposedly defined doesn't seem to be publicly available.)

You need the USB 2.0 spec errata from 2011-11 that describes the changes
made for BESL as well.  It's in the USB2-LPM-Errata-final.pdf and
USB2_LinkPowerMangement_ECN[final].pdf files in this zip file:

http://www.usb.org/developers/docs/usb_20_070113.zip

I agree though, it's all a confusing mess for documentation on USB 2.0
Link PM.

Sarah Sharp
