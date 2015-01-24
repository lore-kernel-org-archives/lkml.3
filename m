Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbbAXLtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:49:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:40245 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAXLtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:49:13 -0500
Date: Sat, 24 Jan 2015 12:48:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/8] irqchip: Supply new driver for STi based
 devices
In-Reply-To: <20150123163231.GB11745@x1>
Message-ID: <alpine.DEB.2.11.1501241246240.5526@nanos>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org> <1421920133-7914-3-git-send-email-lee.jones@linaro.org> <alpine.DEB.2.11.1501231702280.5526@nanos> <20150123163231.GB11745@x1>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Lee Jones wrote:
> On Fri, 23 Jan 2015, Thomas Gleixner wrote:
> > The only technical comment I have is: shouldn't all the stuff except
> > the resume function be marked __init or is any of this required post
> > init?
> 
> It's not common to mark functions invoked at and affter *_probe() as
> __init.  At least, not as far as I'm aware.

Right, if the probe stuff is supposed to be functional post init, then
we of course need to keep it around. But I guess we have no mechanism
to distinguish the 'boot only' and 'keep post init' case. Might be
worthwhile to investigate.

Thanks,

	tglx


