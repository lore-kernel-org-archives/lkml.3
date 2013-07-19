Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3GSVDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:03:17 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:50853 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3GSVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:03:15 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am5nAKyo6VFV5qu1PGdsb2JhbABbgwaDI4UjuQMEAYEQFwMBAQEBODWCJAEBBAE6HCMFCwgDISUPBSUKGjGHbAq3ORaOXIEdB4MQbgOXXIYzji86
X-IronPort-AV: E=Sophos;i="4.89,704,1367964000"; 
   d="scan'208";a="361957330"
From: rydberg@euromail.se
Date: Fri, 19 Jul 2013 23:04:30 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: multitouch: do not init reports for multitouch
 devices
Message-ID: <20130719210430.GA31481@polaris.bitmath.org>
References: <1373620101-16113-1-git-send-email-benjamin.tissoires@redhat.com>
 <20130718192416.GA526@polaris.bitmath.org>
 <CAN+gG=G6jw0BkJejZ=Rb+Vzzey1=JdqiiYmMonwjt9G1R779Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=G6jw0BkJejZ=Rb+Vzzey1=JdqiiYmMonwjt9G1R779Tg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> >> Some multitouch screens do not like to be polled for input reports.
> >> However, the Win8 spec says that all touches should be sent during
> >> each report, making the initialization of reports unnecessary.
> >> The Win7 spec is less precise, but we can safely assume that when
> >> the module is loaded (at boot), no one is touching the screen.
> >>
> >> Add the quirk HID_QUIRK_NO_INIT_REPORTS so that we do not have to
> >> introduce a quirk for each problematic device.
> >
> > I assume you have tested thoroughly for regressions? How about odd
> > eGalax devices, for instance? Changes affecting existing hardware
> > makes me nervous. Is it so bad to add this quirk on a per-device
> > basis? Or perhaps turned on by default for win8 devices only?
> 
> Aargh, I forgot the eGalax... (I don't have it anymore on my desk). I
> was pretty confident because Win [7-8] is not doing any quirks for the
> multitouch devices, and I had in mind that it did not asked for the
> reports at startup (at least, I am sure about it for HID/I2C). I'm not
> sure win 8 devices is a sufficient denominator, because this init
> sequence is not mentioned anywhere in the Win 8 spec. It's true that
> we are going to see fewer Win 7 devices, but I would say it's the
> exact same problem for win 7 and 8. Moreover, asking this for Win 8
> devices only will forces us to detect it in core before hid-multitouch
> is loaded because the init reports is called before the parsing.

We already branch on report specifics in hid_add_device(). Adding win8
detection there is more or less what it was built for.

> If I capture the Win 7 & Win 8 initialization events and I observe
> that they do not retrieve the reports, will it be sufficient as a
> guarantee to include this patch even if it is not widely tested under
> Linux?

We already have the usbhid quirks to handle odd cases, and we can add
all sorts of generic detection during device add, so there really is
no reason to risk regressions at all, is there?

Cheers,
Henrik
