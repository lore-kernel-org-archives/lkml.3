Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaKYJxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:53:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaKYJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:53:47 -0500
Message-ID: <1416909225.2918.9.camel@linux-0dmf.site>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Oliver Neukum <oneukum@suse.de>
To: Benson Leung <bleung@chromium.org>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Date: Tue, 25 Nov 2014 10:53:45 +0100
In-Reply-To: <CANLzEkv5MM8sT3WsPyqYvn=H_MHkuuELsfZQfJtJA0dwzdruKg@mail.gmail.com>
References: <1415909806-23848-1-git-send-email-bleung@chromium.org>
	 <1415956110.2640.5.camel@linux-0dmf.site>
	 <CANLzEkvcm5g_T+FsEQF2UFzS5A2u7CWgdTiEJAxidfxgAE5bHw@mail.gmail.com>
	 <1416820395.19925.4.camel@linux-0dmf.site>
	 <CANLzEkv5MM8sT3WsPyqYvn=H_MHkuuELsfZQfJtJA0dwzdruKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 16:56 -0800, Benson Leung wrote:
> Hi Oliver,
> 
> On Mon, Nov 24, 2014 at 1:13 AM, Oliver Neukum <oneukum@suse.de> wrote:
> >
> > But there is very little to be gained by switching off remote wakeup.
> > The additional energy consumption devices with remote wakeup enabled
> > will be dwarfed by the energy needed for an additional wakeup.
> >
> 
> That makes sense to me. Does this mean we should be moving toward a
> solution that doesn't wake suspended devices on close for other usb
> devices, not just hid?
> 
> This particular pattern of get()/needs_remote_wakeup=0/put() on
> close() appears in several other drivers, for example :
> 62ecae0 Input: wacom - properly enable runtime PM
> 5d9efc5 Input: usbtouchscreen - implement runtime power management

Yes, we should never wake up a device just to unset remote
wakeup for runtime PM. In hindsight those patches were clumsy.

	Regards
		Oliver


