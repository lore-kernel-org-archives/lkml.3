Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3CSTOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:14:42 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:38506 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3CSTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGtLcuSsoumAgdB7ri+fR5ReNYcZELbqDcSueXVsewppg@mail.gmail.com>
References: <CAKMK7uGnZFaLQaZtoQ0Fz0ViNNjBvmf0Ak=qPmdAcm2mRBD7rA@mail.gmail.com>
	<Pine.LNX.4.44L0.1303191136020.15684-100000@netrider.rowland.org>
	<CAKMK7uGtLcuSsoumAgdB7ri+fR5ReNYcZELbqDcSueXVsewppg@mail.gmail.com>
Date: Tue, 19 Mar 2013 12:14:39 -0700
X-Google-Sender-Auth: QcisJeKj-nbPlkGmrouqeL6VE-g
Message-ID: <CAE9FiQUyr4Tjw9F6o8FMf0+WMSFuucanskTT7e=eqjvRqi0HPQ@mail.gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1] irq
 16: nobody cared (was [3.9-rc1] very poor interrupt responses
From: Yinghai Lu <yinghai@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Chris Wilson <chris@chris-wilson.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        Greg KH <greg@kroah.com>, Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 9:54 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> I guess I should have phrased it more precisely, but that's exactly
> what I expect is happening on my machine: I don't have anything on
> irq16 (i.e. in non-msi mode the gfx interrupt isn't shared) and hence
> the irq is completely disabled. Which obviously makes it impossible
> for me to reproduce the issue. To test that theory, is there a quick
> way to force-enable a given interrupt, short of just hacking up a 2nd
> dummy irq handler in my driver?

You may try to add another request_irq()
after i915_load_modeset_init==>drm_irq_install.
That could install one dummy action for ioapic irq for i915.

Also you may need to add one quirk that does not disable intx during
msi enabling like:
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,
                        0x2e22,
                        quirk_msi_intx_disable_bug);

Thanks

Yinghai
