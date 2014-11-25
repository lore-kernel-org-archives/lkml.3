Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaKYA47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:56:59 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39075 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaKYA44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:56:56 -0500
MIME-Version: 1.0
In-Reply-To: <1416820395.19925.4.camel@linux-0dmf.site>
References: <1415909806-23848-1-git-send-email-bleung@chromium.org>
	<1415956110.2640.5.camel@linux-0dmf.site>
	<CANLzEkvcm5g_T+FsEQF2UFzS5A2u7CWgdTiEJAxidfxgAE5bHw@mail.gmail.com>
	<1416820395.19925.4.camel@linux-0dmf.site>
Date: Mon, 24 Nov 2014 16:56:56 -0800
X-Google-Sender-Auth: k76Pyu4Vbnd45FE-Mut6rk_NOK4
Message-ID: <CANLzEkv5MM8sT3WsPyqYvn=H_MHkuuELsfZQfJtJA0dwzdruKg@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Benson Leung <bleung@chromium.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Mon, Nov 24, 2014 at 1:13 AM, Oliver Neukum <oneukum@suse.de> wrote:
>
> But there is very little to be gained by switching off remote wakeup.
> The additional energy consumption devices with remote wakeup enabled
> will be dwarfed by the energy needed for an additional wakeup.
>

That makes sense to me. Does this mean we should be moving toward a
solution that doesn't wake suspended devices on close for other usb
devices, not just hid?

This particular pattern of get()/needs_remote_wakeup=0/put() on
close() appears in several other drivers, for example :
62ecae0 Input: wacom - properly enable runtime PM
5d9efc5 Input: usbtouchscreen - implement runtime power management


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
