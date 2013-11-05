Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3KEMuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:50:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KEMuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:50:15 -0500
Date: Tue, 5 Nov 2013 04:52:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] staging: new asus fan driver
Message-ID: <20131105125228.GB18093@kroah.com>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:59:47AM -0600, Felipe Contreras wrote:
> Simple driver to enable control of the fan in ASUS laptops. So far this
> has only been tested in ASUS Zenbook Prime UX31A, but according to some
> online reference [1], it should work in other models as well.
> 
> The implementation is very straight-forward, the only caveat is that the
> fan speed needs to be saved after it has been manually changed because
> it won't be reported properly until it goes back to 'auto' mode.
> 
> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
> 
> Two incarnations of this code exists [1][2], one that used ACPI methods
> directly, and one through WMI. Unfortunately the WMI version needs us to pass
> physicall addresses which is not exactly clean, and that's the only reason the
> code is proposed for staging.
> 
> Most likely this cannot graduate until acpica gets support to receive virtual
> addresses.

When is that going to happen?

> 
>  [1] http://article.gmane.org/gmane.linux.power-management.general/36774
>  [2] http://article.gmane.org/gmane.linux.kernel/1576463
> 
>  drivers/staging/Kconfig                     |   2 +
>  drivers/staging/Makefile                    |   1 +
>  drivers/staging/asus-thermal/Kconfig        |   7 ++
>  drivers/staging/asus-thermal/asus_thermal.c | 166 ++++++++++++++++++++++++++++

I need a TODO file for a staging driver listing who is responsible for
it, and what is needed to be done to it in order to get it out of
staging.

thanks,

greg k-h
