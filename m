Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3CHVAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:00:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab3CHVAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:00:46 -0500
Date: Fri, 8 Mar 2013 22:00:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: holtek: Holtek devices depends on USB_HID
In-Reply-To: <513A4FA2.6070309@infradead.org>
Message-ID: <alpine.LNX.2.00.1303082159140.19460@pobox.suse.cz>
References: <1362649709-9608-1-git-send-email-benjamin.tissoires@redhat.com> <513A4FA2.6070309@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Randy Dunlap wrote:

> > In the HID drivers tranport cleanup series, I removed the dependency
> > between hid-holtek and usbhid. This was wrong as hid-holtek.c relies
> > extensively on usb calls.
> > 
> > This fixes compilation error when CONFIG_USB_SUPPORT is not enabled.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> 
> but hid-multitouch build still fails (on 3.9-rc1) when USB_SUPPORT is not enabled:

Are you sure about 3.9-rc1? It has USB_HID dependency for HID_MUTLTIOUCH, 
hence that shouldn't be a problem.

There used to be a problem in linux-next, but that should be fixed by 
4ba25d3f87 ("HID: multitouch: remove last usb dependency"), which I have 
pushed out yesterday.

-- 
Jiri Kosina
SUSE Labs
