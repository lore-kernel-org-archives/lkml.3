Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaFNFds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 01:33:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaFNFdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 01:33:44 -0400
Date: Sat, 14 Jun 2014 07:33:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ao2@ao2.it>
cc: Jamie Lentin <jm@lentin.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Add support for Compact (Bluetooth|USB) keyboard
 with Trackpoint
In-Reply-To: <20140613234538.c960b52757f554699f2dbd1f@ao2.it>
Message-ID: <alpine.LNX.2.00.1406140731420.1321@pobox.suse.cz>
References: <1402439094-25464-1-git-send-email-jm@lentin.co.uk> <1402439094-25464-3-git-send-email-jm@lentin.co.uk> <20140611103616.79b40e7b0bbf3447837921fc@ao2.it> <alpine.DEB.2.02.1406112253440.4059@marmot.wormnet.eu>
 <20140613234538.c960b52757f554699f2dbd1f@ao2.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Antonio Ospite wrote:

> > Previously the tpkbd driver had various functions marked "_tp" to indicate 
> > that it's for the "mouse" half of the keyboard as the kernel sees it, 
> > however it does nothing special with the keyboard half. I was intending 
> > (somewhat sloppily) to repurpose this into having versions of each 
> > function for each keyboard, and a common function to switch between them. 
> > Should make it fairly easy to add extra keyboards in the future.
> > 
> > The problem, as ever, is choosing decent names for them. It should 
> > probably be either:-
> > 
> > * tpkbd_input_mapping_usbkbd
> > * tpkbd_input_mapping_compactkbd
> > ...and tpkbd_input_mapping switches between them
> > 
> > or rename the driver to hid-lenovo and do:-
> > 
> 
> I am OK with a rename. Most files in drivers/hid are per-vendor after
> all. Jiri?

Fine by me; the module doesn't take any parameters, so we are not risking 
introducing regression for people who'd have put parameter settings in 
modprobe.conf or some such.

So please go ahead with the rename.

-- 
Jiri Kosina
SUSE Labs
