Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaKFTG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:06:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFTGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:06:54 -0500
Date: Thu, 6 Nov 2014 11:06:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 0/4] fix serial console suspend on PNP
Message-ID: <20141106190653.GA17356@kroah.com>
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:40:50PM -0500, Peter Hurley wrote:
> Hi Greg,
> 
> The kernel command line parameter, no_console_suspend, enables the serial
> console to continue to output kernel message during system suspend/resume.
> 
> However, the PNP bus will disable and power-down pnp devices on system
> suspend, which defeats the purpose of no_console_suspend; namely to continue
> to output messages in case those are the last messages before crashing.
> 
> The first patch is a cleanup of the baroque logic of uart_suspend_port().
> The second patch overrides the PNP bus disabling the console device if
> no_console_suspend is set. This patch uses existing PNP bus logic but
> perhaps in a way not originally intended.
> The third patch requires Rafael's ack, as it adds a capability to allow
> the device to override the power-down function.
> The fourth patch actually performs the power-down override enabled by
> patch 3.
> 
> With these patches, the PNP0501 device (16550A uart) will continue to
> output messages while system suspend finishes, as intended by the
> no_console_suspend parameter. [System resume is another problem, which
> I'm working on].
> 
> Regards,
> 
> Peter Hurley (4):
>   serial: core: Simplify console suspend logic in uart_suspend_port()
>   serial: 8250_pnp: Override pnp disable for no_console_suspend
>   PNP: Allow device to override ACPI device sleep
>   serial: 8250_pnp: Override pnp suspend for no_console_suspend
> 
>  drivers/pnp/driver.c               |  2 +-
>  drivers/pnp/pnpacpi/core.c         |  2 +-
>  drivers/tty/serial/8250/8250_pnp.c | 61 +++++++++++++++++++++++++++++++-------
>  drivers/tty/serial/serial_core.c   | 35 +++++++++++-----------
>  include/linux/pnp.h                |  3 ++
>  5 files changed, 72 insertions(+), 31 deletions(-)

I'll drop these for now and wait for a second round of these patches.

thanks,

greg k-h
