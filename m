Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3A2U5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:57:05 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:44093 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3A2U5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:57:01 -0500
Message-ID: <5108378F.80003@ahsoftware.de>
Date: Tue, 29 Jan 2013 21:56:47 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
References: <50F2A310.5010006@ahsoftware.de> <1359139768-32294-1-git-send-email-holler@ahsoftware.de> <1359139768-32294-2-git-send-email-holler@ahsoftware.de> <20130128162238.7fba92fe.akpm@linux-foundation.org> <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de> <5107AE4F.9000809@ahsoftware.de> <5107F014.4030704@ahsoftware.de> <5108329E.2050802@ahsoftware.de>
In-Reply-To: <5108329E.2050802@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.01.2013 21:35, schrieb Alexander Holler:
>
> So, if the above down_timeout_killable() is only down_interruptible(),
> as in kernel 3.7.5, the  box would not shutdown afterwards, because on
> shutdown no signal would be send to that kernel-thread which called
> dlfb_free_urb_list().
>
> A last note: dlfb_usb_disconnect() (thus dlfb_free_urb_list()) isn't
> called on shutdown if the device would still be connected. So the
> problem only might happen, if the screen will be disconnected before
> shutdown (and an urb gets missed). So the subject of my patch is
> correct. ;)
>
> </monologue>

Hmm, wrong, sorry, I still have something to add: As no signal arrives 
at all, v1 of that patch is enough and the implementation of 
down_timeout_killable() isn't necessary at all.

If there is a chance that the patch would be Acked-by by someone, I 
would made a v3, replacing

+		ret = down_timeout(&dev->urbs.limit_sem, GET_URB_TIMEOUT);

in v1 with

+		ret = down_timeout(&dev->urbs.limit_sem, FREE_URB_TIMEOUT);

as this seems to be what it should be.

Regards,

Alexander
