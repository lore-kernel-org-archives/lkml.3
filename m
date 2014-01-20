Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaATXv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:51:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaATXvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:51:23 -0500
Date: Mon, 20 Jan 2014 15:52:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>, Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140120235209.GB5012@kroah.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140120214305.54f65ffa@www.etchedpixels.co.uk>
 <20140120231457.GZ17314@sirena.org.uk>
 <20140120232141.GM15937@n2100.arm.linux.org.uk>
 <20140120233541.593d0918@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120233541.593d0918@www.etchedpixels.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 11:35:41PM +0000, Alan Cox wrote:
> > The first bit is easy... but we need to add locks to every serial
> > driver to prevent two probes operating concurrently...
> 
> The bus probe should already be serializing surely ?

Yes, it better be, otherwise that bus is badly broken.

greg k-h
