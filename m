Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3A2PwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:52:04 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47368 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3A2PwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:52:00 -0500
Message-ID: <5107F014.4030704@ahsoftware.de>
Date: Tue, 29 Jan 2013 16:51:48 +0100
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
References: <50F2A310.5010006@ahsoftware.de> <1359139768-32294-1-git-send-email-holler@ahsoftware.de> <1359139768-32294-2-git-send-email-holler@ahsoftware.de> <20130128162238.7fba92fe.akpm@linux-foundation.org> <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de> <5107AE4F.9000809@ahsoftware.de>
In-Reply-To: <5107AE4F.9000809@ahsoftware.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.01.2013 12:11, schrieb Alexander Holler:

>
> To explain the problem on shutdown a bit further, I think the following
> happens (usb and driver are statically linked and started by the kernel):
>
> shutdown -> kill signal -> usb stack shuts down -> udlfb waits (forever)
> for a kill or an urb which it doesn't get.

Having a second look at what I've written above, I'm not even sure if 
the kernel sends one or more fatal signals on shutdown at all. I've just 
assumed it because otherwise down_interruptible() wouldn't have worked 
before (it would have stalled on shutdown too (if an urb got missed), 
not only on disconnect).

Sounds like an interesting question I should read about (if/when fatal 
signals are issued by the kernel). ;)

> Maybe the sequence is different if the usb-stack and udlfb are used as a
> module and/or udlfb is used only for X/fb. I'm not sure what actually
> does shut down the usb-stack in such a case, but maybe more than one
> kill signal might be thrown around.

Regards,

Alexander
