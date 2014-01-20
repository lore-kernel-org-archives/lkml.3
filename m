Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaATKE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:04:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42607 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750756AbaATKEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:04:25 -0500
Date: Mon, 20 Jan 2014 10:04:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, ben.dooks@codethink.co.uk,
        broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
	device probe
Message-ID: <20140120100415.GX15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 02:32:35PM +0530, Tushar Behera wrote:
> uart_register_driver call binds the driver to a specific device
> node through tty_register_driver call. This should typically happen
> during device probe call.
> 
> In a multiplatform scenario, it is possible that multiple serial
> drivers are part of the kernel. Currently the driver registration fails
> if multiple serial drivers with same default major/minor numbers are
> included in the kernel.
> 
> A typical case is observed with amba-pl011 and samsung-uart drivers.

NAK.  There should not be any other driver using amba-pl011's device numbers.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
