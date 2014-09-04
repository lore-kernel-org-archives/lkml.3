Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaIDJGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:06:08 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:57900 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbaIDJGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:06:03 -0400
X-ASG-Debug-ID: 1409821560-0759e778ba667350002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Thu, 4 Sep 2014 11:05:47 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Johan Hovold <johan@kernel.org>
CC: Frans Klaver <fransklaver@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
Message-ID: <20140904090546.GA6213@ci00147.test>
X-ASG-Orig-Subj: Re: [PATCH resend 2/2] usb: serial: xsens_mt: always bind to
 interface number 1
References: <1409564362-27571-1-git-send-email-frans.klaver@xsens.com>
 <1409564362-27571-2-git-send-email-frans.klaver@xsens.com>
 <CAH6sp9Me6wVTnNGn9Z4pLDsFyTz27EgcEvedF8PrcH-fw+awBQ@mail.gmail.com>
 <20140904081522.GD4894@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140904081522.GD4894@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1409821560
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9162
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:15:22AM +0200, Johan Hovold wrote:
> On Thu, Sep 04, 2014 at 09:12:05AM +0200, Frans Klaver wrote:
> 
> > >  static int xsens_mt_probe(struct usb_serial *serial,
> > >                                         const struct usb_device_id *id)
> > >  {
> > > -       if (!has_required_endpoints(serial->interface->cur_altsetting))
> > > -               return -ENODEV;
> > > -       return 0;
> > > +       if (serial->interface->cur_altsetting.desc.bInterfaceNumber == 1)
> > 
> > This should be
> > 
> > if (serial->interface->cur_altsetting->desc.bInterfaceNumber == 1)
> 
> So this wasn't even compile tested. Always test your patches before
> submission, including trivial ones.
> 
> Is the new version tested on actual hardware?

The implementation was tested (also fixed) before the first submission.
Not the patches. Looks like I've got a step to add.

The new version is applied, built and tested with some actual hardware
on 3.17-rc3.

Frans
