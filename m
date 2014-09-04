Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaIDIQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:16:48 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:45092 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbaIDIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:16:45 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 4 Sep 2014 10:15:22 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
Message-ID: <20140904081522.GD4894@localhost>
References: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
 <1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
 <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:12:05AM +0200, Frans Klaver wrote:

> >  static int xsens_mt_probe(struct usb_serial *serial,
> >                                         const struct usb_device_id *id)
> >  {
> > -       if (!has_required_endpoints(serial->interface->cur_altsetting))
> > -               return -ENODEV;
> > -       return 0;
> > +       if (serial->interface->cur_altsetting.desc.bInterfaceNumber == 1)
> 
> This should be
> 
> if (serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)

So this wasn't even compile tested. Always test your patches before
submission, including trivial ones.

Is the new version tested on actual hardware?

Johan
