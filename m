Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaEDAxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 20:53:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEDAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 20:53:50 -0400
Date: Sat, 3 May 2014 19:17:26 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-doc@vger.kernel.org, t.figa@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        robh+dt@kernel.org, arnd@arndb.de, grant.likely@linaro.org,
        kgene.kim@samsung.com, rdunlap@infradead.org, ben-linux@fluff.org
Subject: Re: [PATCH 0/2] Add support for sii9234 chip
Message-ID: <20140503231726.GA20212@kroah.com>
References: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:48:28PM +0200, Tomasz Stanislawski wrote:
> Hi everyone,
> This patchset adds support for sii9234 HD Mobile Link Bridge.  The chip is used
> to convert HDMI signal into MHL.  The driver enables HDMI output on Trats and
> Trats2 boards.
> 
> The code is based on the driver [1] developed by:
>        Adam Hampson <ahampson@sta.samsung.com>
>        Erik Gilling <konkers@android.com>
> with additional contributions from:
>        Shankar Bandal <shankar.b@samsung.com>
>        Dharam Kumar <dharam.kr@samsung.com>
> 
> The drivers architecture was greatly simplified and transformed into a form
> accepted (hopefully) by opensource community.  The main differences from
> original code are:
> * using single I2C client instead of 4 subclients
> * remove all logic non-related to establishing HDMI link
> * simplify error handling
> * rewrite state machine in interrupt handler
> * wakeup and discovery triggered by an extcon event
> * integrate with Device Tree
> 
> For now, the driver is added to drivers/misc/ directory because it has neigher
> userspace nor kernel interface.  The chip is capable of receiving and
> processing CEC events, so the driver may export an input device in /dev/ in the
> future.  However CEC could be also handled by HDMI driver.
> 
> I kindly ask for suggestions about the best location for this driver.

It really is an extcon driver, so why not put it in drivers/extcon?  And
that might solve any build issues you have if you don't select extcon in
your .config file and try to build this code :)

thanks,

greg k-h
