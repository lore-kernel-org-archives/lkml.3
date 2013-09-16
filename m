Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3IPRN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:13:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53949 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3IPRNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:13:25 -0400
Date: Mon, 16 Sep 2013 10:13:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
 synthetic keyboard
Message-ID: <20130916171320.GC20734@core.coreip.homeip.net>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916152019.GB12105@core.coreip.homeip.net>
 <076938490f5141ef957947dc10b82c65@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <076938490f5141ef957947dc10b82c65@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 03:52:18PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Monday, September 16, 2013 8:20 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; linux-input@vger.kernel.org; vojtech@suse.cz;
> > olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> > Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
> > synthetic keyboard
> > 
> > Hi K. Y.
> > 
> > On Sun, Sep 15, 2013 at 10:28:54PM -0700, K. Y. Srinivasan wrote:
> > > Add a new driver to support synthetic keyboard. On the next generation
> > > Hyper-V guest firmware, many legacy devices will not be emulated and this
> > > driver will be required.
> > >
> > > I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> > > details of the AT keyboard driver.
> > >
> > 
> > In addition to what Dan said:
> > 
> > > +
> > > +struct synth_kbd_protocol_response {
> > > +	struct synth_kbd_msg_hdr header;
> > > +	u32 accepted:1;
> > > +	u32 reserved:31;
> > > +};
> > 
> > Use of bitfields for on the wire structures makes me uneasy. I know that
> > currently you only going to run LE on LE, but still, maybe using
> > explicit shifts and masks would be better,
> 
> This definition of the data structure is defined by the host. I will see what I
> can do here.

You do not really need to change protocol, you just sat that accepted is
the bit 0 of the word and define endianness (LE in your case). Then you
do:

	struct synth_kbd_protocol_response {
		struct synth_kbd_msg_hdr header;
		__le32 status;
	}

	#define KBD_PROTOCOL_ACCEPTED BIT(0)

	...

	status = _le32_to_cpu(response->status);
	accepted = status & KBD_PROTOCOL_ACCEPTED;

Thanks.

-- 
Dmitry
