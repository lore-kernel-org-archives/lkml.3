Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbaFTHl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:41:56 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63837 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934161AbaFTHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:41:55 -0400
Message-ID: <1403250112.22857.7.camel@x220>
Subject: Re: [PATCH v5 01/15] thunderbolt: Add initial cactus ridge NHI
 support
From: Paul Bolle <pebolle@tiscali.nl>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Date: Fri, 20 Jun 2014 09:41:52 +0200
In-Reply-To: <1401825852-4745-2-git-send-email-andreas.noever@gmail.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
	 <1401825852-4745-2-git-send-email-andreas.noever@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jun 2014 07:41:52.0882 (UTC) FILETIME=[1A567520:01CF8C5B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 22:03 +0200, Andreas Noever wrote:
> Thunderbolt hotplug is supposed to be handled by the firmware. But Apple
> decided to implement thunderbolt at the operating system level. The
> firmare only initializes thunderbolt devices that are present at boot
> time. This driver enables hotplug of thunderbolt of non-chained
> thunderbolt devices on Apple systems with a cactus ridge controller.
> 
> This first patch adds the Kconfig file as well the parts of the driver
> which talk directly to the hardware (that is pci device setup, interrupt
> handling and RX/TX ring management).
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> ---

This patch landed in today's linux-next (next-20140620).

> [...]
> --- /dev/null
> +++ b/drivers/thunderbolt/Kconfig
> @@ -0,0 +1,12 @@
> +menuconfig THUNDERBOLT
> +	tristate "Thunderbolt support for Apple devices"
> +	default no

That should have been "default n". But "n" is the default anyway, so I'd
say this line might as well be dropped. Should I draft the trivial patch
to do that?

> +	help
> +	  Cactus Ridge Thunderbolt Controller driver
> +	  This driver is required if you want to hotplug Thunderbolt devices on
> +	  Apple hardware.
> +
> +	  Device chaining is currently not supported.
> +
> +	  To compile this driver a module, choose M here. The module will be
> +	  called thunderbolt.

(Naive question: is Thunderbolt relevant outside x86_64?)


Paul Bolle

