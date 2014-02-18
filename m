Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaBRSvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:51:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaBRSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:51:03 -0500
Date: Tue, 18 Feb 2014 10:52:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Mark Jackson <mpfj@mimc.co.uk>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 2/2] misc: add missing minor nodes
Message-ID: <20140218185228.GC29209@kroah.com>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
 <1392701245-4645-3-git-send-email-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392701245-4645-3-git-send-email-lucas.demarchi@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:27:25AM -0300, Lucas De Marchi wrote:
> From: Lucas De Marchi <lucas.demarchi@intel.com>
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> ---
>  Documentation/devices.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 04356f5..0ea1cc2 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -329,6 +329,7 @@ Your cooperation is appreciated.
>  		filesystem across multiple physical disks.
>  
>   10 char	Non-serial mice, misc features
> +		  0 = /dev/fram
>  		  0 = /dev/logibm	Logitech bus mouse
>  		  1 = /dev/psaux	PS/2-style mouse port
>  		  2 = /dev/inportbm	Microsoft Inport bus mouse

That's not ok at all, and probably a bug, someone must have thought that
minor 0 ment "give me a dynamic number."  No one caught this when the
driver was first merged in a arch-specific tree in 2008 :(

In looking at the driver, it probably should just be a UIO driver, or
something else, all it does it map frame buffer memory to userspace,
given the hardware involved, odds are no one even uses it anymore...

Mark and Haavard, any thoughts about the
arch/avr32/boards/mimc200/fram.c driver?  Can I fix up the minor number
here, or just delete the driver entirely if it's not being used anymore?

greg k-h
