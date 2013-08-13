Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3HMSUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:20:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3HMSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:20:13 -0400
Date: Tue, 13 Aug 2013 11:20:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
Message-ID: <20130813182012.GE7740@kroah.com>
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:34:30PM +0300, Pantelis Antoniou wrote:
> This is a very simple device that allows testing of the removal path
> for platform devices.
> 
> The only interface is a single writeable sysfs attribute (action).

Why not use the existing "unbind/bind" sysfs files that all busses
support?  That's what userspace is expecting to use for adding and
removing devices from drivers from userspace.

This is a per-driver flag that the function platform_driver_probe() sets
for all platform drivers in the first line of that function.  Remove
that line and see what happens :)

thanks,

greg k-h
