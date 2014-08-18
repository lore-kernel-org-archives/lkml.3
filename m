Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHRSwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:52:04 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38022 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:52:02 -0400
Date: Mon, 18 Aug 2014 11:51:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Message-ID: <20140818185151.GB31121@core.coreip.homeip.net>
References: <1408095719-19117-1-git-send-email-decui@microsoft.com>
 <20140815165733.GB25225@core.coreip.homeip.net>
 <EE124450C0AAF944A40DD71E61F878C9933040@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9933040@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 03:54:51AM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Dmitry Torokhov
> > Sent: Saturday, August 16, 2014 0:58 AM
> > To: Dexuan Cui
> > > For each char in the string, the host sends 2 events (key down/up with the
> > > char's UNICODE value) to the guest.
> > > The patch finds each char's scan codes of key down/up, and injects the
> > > scan codes to the serio keyboard module.
> > >
> > > Known issues:
> > > 1) Only printable ASCII chars are supported, and unsupported chars are
> > > ignored. It seems unlikely to support generic UNICODE chars because there
> > > is not a generic API to inject a UNICODE char to text mode console, KDE,
> > > gnome, etc.
> > >
> > > 2) When we use the feature, make sure the CapsLock state of the VM's
> > > (virtual) keyboard is OFF because this patch assumes it -- we'll try to
> > > fix this later, probably by tracking the state of virtual CapsLock, because
> > > it looks the keyboard module doesn't supply an API for us to query the
> > state
> > > of the keyboard.
> > >
> > No way. If you want to do this this way, do it in hypervisor code and keep
> > feeding AT scan codes to hyperv-keyboard, although I am pretty sure users
> Hi Dmitry,
> Yeah, I had the same wish, but later I found this seems unlikely because IMO
> the feature was firstly invented for Windows VM + generic UNICODE chars,
> and we know there is no "scan code" for generic UNICODE chars... :-(

Do you know what guest is running? You could potentially gate on that.

> 
> > of
> > French, Czech and other keyboard layouts with numbers in upper register
> > and
> > symbols in lower will have a few choice words for you.
> Sorry, I can't understand what these are.
> Can you please give more details or a link to further info?

On French and many other European layouts to produce a number one needs to use
Shift key, instead of simply using lower register, as on US or UK layouts. I.e.
if you send scancode for KEY_3 through your proposed implementation it will
produce '#' and KEY_SHIFT + KEY_3 will result in '3'.

There are also issues with QWERTY/AZERTY and other layouts...

Thanks.

-- 
Dmitry
