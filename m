Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaHOQ5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:57:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49273 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHOQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:57:40 -0400
Date: Fri, 15 Aug 2014 09:57:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Message-ID: <20140815165733.GB25225@core.coreip.homeip.net>
References: <1408095719-19117-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408095719-19117-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dexuan,

On Fri, Aug 15, 2014 at 02:41:59AM -0700, Dexuan Cui wrote:
> In the menu of the Hyper-V's Virtual Machine Connection, there is a feature
> called "Clipboard | Type clipboard text", which can be used to copy a string
> in the host's clipboard into the guest's current input focus(text console or
> a GUI window).
> 
> Currently the feature doesn't work for Linux VM because the driver
> hyperv-keyboard hasn't been enhanced to support it -- this patch is made
> to do it.
> 
> For each char in the string, the host sends 2 events (key down/up with the
> char's UNICODE value) to the guest.
> The patch finds each char's scan codes of key down/up, and injects the
> scan codes to the serio keyboard module.
> 
> Known issues:
> 1) Only printable ASCII chars are supported, and unsupported chars are
> ignored. It seems unlikely to support generic UNICODE chars because there
> is not a generic API to inject a UNICODE char to text mode console, KDE,
> gnome, etc.
> 
> 2) When we use the feature, make sure the CapsLock state of the VM's
> (virtual) keyboard is OFF because this patch assumes it -- we'll try to
> fix this later, probably by tracking the state of virtual CapsLock, because
> it looks the keyboard module doesn't supply an API for us to query the state
> of the keyboard.
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

No way. If you want to do this this way, do it in hypervisor code and keep
feeding AT scan codes to hyperv-keyboard, although I am pretty sure users of
French, Czech and other keyboard layouts with numbers in upper register and
symbols in lower will have a few choice words for you.

If you want real cut-and-paste support in various DEs I'd recommend working
with VMware on open-vm-tools package to see what can be shared/reused there.

Consider this NACked with prejudice.

Thanks.


-- 
Dmitry
