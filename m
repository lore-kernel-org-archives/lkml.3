Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaIDJXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:23:53 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36459 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaIDJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:23:49 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 4 Sep 2014 11:22:26 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, Frans Klaver <fransklaver@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
Message-ID: <20140904092226.GE4894@localhost>
References: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
 <1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
 <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
 <20140904081522.GD4894@localhost>
 <20140904090546.GA6213@ci00147.test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904090546.GA6213@ci00147.test>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:05:47AM +0200, Frans Klaver wrote:
> On Thu, Sep 04, 2014 at 10:15:22AM +0200, Johan Hovold wrote:
> > On Thu, Sep 04, 2014 at 09:12:05AM +0200, Frans Klaver wrote:
> > 
> > > >  static int xsens_mt_probe(struct usb_serial *serial,
> > > >                                         const struct usb_device_id *id)
> > > >  {
> > > > -       if (!has_required_endpoints(serial->interface->cur_altsetting))
> > > > -               return -ENODEV;
> > > > -       return 0;
> > > > +       if (serial->interface->cur_altsetting.desc.bInterfaceNumber == 1)
> > > 
> > > This should be
> > > 
> > > if (serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
> > 
> > So this wasn't even compile tested. Always test your patches before
> > submission, including trivial ones.
> > 
> > Is the new version tested on actual hardware?
> 
> The implementation was tested (also fixed) before the first submission.
> Not the patches. Looks like I've got a step to add.
> 
> The new version is applied, built and tested with some actual hardware
> on 3.17-rc3.

Good. Both patches applied now.

Thanks,
Johan
