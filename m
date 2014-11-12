Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaKLHAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:00:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaKLHAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:00:43 -0500
Message-ID: <1415775644.1761.1.camel@linux-0dmf.site>
Subject: Re: [PATCH] brcmfmac: unlink URB when request timed out
From: Oliver Neukum <oneukum@suse.de>
To: Mathy Vanhoef <vanhoefm@gmail.com>
Cc: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
        John Linville <linville@tuxdriver.com>, pieterpg@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Nov 2014 08:00:44 +0100
In-Reply-To: <5462B1A3.9020401@gmail.com>
References: <545FAE05.2030701@gmail.com>
	 <1415610506.16488.20.camel@linux-0dmf.site> <5462B1A3.9020401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 20:02 -0500, Mathy Vanhoef wrote:
> On 11/10/2014 04:08 AM, Oliver Neukum wrote:

> > Which means that you are freeing memory that may still be used by DMA
> > at this time.
> > In addition you have no guarantee that the unlink is indeed finished
> > by the time the URB is reused.
> > If you wish to take this approach you better forget about this URB
> > and allocate a new one and free the buffer from the callback.
> 
> Hi Oliver,
> 
> Good catch. I think the DMA issue is also present in the current driver: it
> frees the buffer without unlinking/killing the URB at all. Can a malicious USB

Yes, it is present.

> device force a timeout to occur (i.e. delay the call to the completion
> handler)? If so this might be a use-after-free vulnerability.
> 
> It seems using usb_kill_urb instead of usb_unlink_urb in the patch prevents any
> possible use-after-free. Can someone double check?

usb_kill_urb() will do the job.

	Regards
		Oliver


