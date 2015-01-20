Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbbATKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:30:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:47675 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATKaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:30:15 -0500
Date: Tue, 20 Jan 2015 11:29:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: earlyprintk cleanup
In-Reply-To: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
Message-ID: <alpine.DEB.2.11.1501201103360.5526@nanos>
References: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Alexander Kuleshov wrote:

> The following two patches remove unused macro definitions from 
> early_serial_console and early_printk x86 code.

Sigh. These mechanical 'follow the output of some code analyzer'
changes are really horrible.

Why not doing the obvious: Move the duplicated defines into a common
header file and be done with it?

And if you look deeper, then you'll notice that those defines are used
in two other files as well.

What's worse is that the whole set of defines is readily available in
include/uapi/linux/serial_reg.h already (just with different symbols).

So what's the point of these removal patches?

Thanks,

	tglx

