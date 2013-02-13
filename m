Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3BMNrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:47:17 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43503 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3BMNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:47:16 -0500
Message-ID: <511B995E.3030905@mev.co.uk>
Date: Wed, 13 Feb 2013 13:47:10 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Peter Huewe <peterhuewe@gmx.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Fix undefined array subscript
References: <1360726254-7895-1-git-send-email-peterhuewe@gmx.de> <20130213073214.GR4937@mwanda> <511B7F58.4000909@mev.co.uk>
In-Reply-To: <511B7F58.4000909@mev.co.uk>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-13 11:56, Ian Abbott wrote:
> For a digital output subdevice, you could either read back the current
> values directly from the hardware or just use the value previously
> written.  The Velleman K8055 doesn't have a command to read back the
> digital outputs from the hardware, so the last written value has to be
> used.  But what if the digital outputs have never been written (or the
> analog outputs have never been written, since the same command updates
> all analog and digital channels)?  A "reset" command is sent to the
> hardware on initialization by vmk80xx_reset_device() (only called for
> the K8055), but I don't know what effect this has on the actual digital
> (and analog) outputs (though I could find out easily enough as we appear
> to have one of these kits (assembled) lying around in the office).  If
> necessary, we may have to also send a "write" command on initialization
> to make the hardware outputs match the initial software state.

I've had a quick play with a K8055 and it seems the "reset" command 
issued during hardware initialization has no effect on the digital 
outputs.  (I tested this by setting some digital outputs with comedi 
instructions - there are some handy LEDs on the board that light up or 
not according to the state of the digital outputs - then rmmod'ing and 
modprobe'ing the vmk80xx module - the LEDs remained in the same state.)

Since we can't read back the outputs on this board we should initialize 
them to a known state.  I'll submit some patches later.

Nothing to do with the patch in this thread, which has my Ack.

Acked-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
