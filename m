Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaHVOA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:00:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35554 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932101AbaHVOAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:00:55 -0400
Date: Fri, 22 Aug 2014 10:00:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
cc: linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
In-Reply-To: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1408220956560.1291-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Kiran Kumar Raparthy wrote:

> From: Todd Poynor <toddpoynor@google.com>
> 
> USB: OTG: Hold wakeupsource when VBUS present
> 
> Enabled by default, can disable with:
>    echo N > /sys/module/otg_wakeupsource/parameters/enabled
> 
> This is one of the number of patches from the Android AOSP common.git tree,
> which is used on almost all Android devices. so I wanted to submit it for
> review to see if it should go upstream.

> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
>  config USB_PHY
>  	def_bool n
>  
> +config USB_OTG_WAKEUPSOURCE
> +	bool "Hold a wakeupsource when USB connected"
> +	depends on PM_SLEEP
> +	select USB_PHY
> +	help
> +	  Select this to automatically hold a wakeupsource when USB is
> +	  connected, preventing suspend.

Without commenting on the appropriateness of this change, I'd like to
point out that users will not understand either the Kconfig symbol name
or the help text.  The help text, especially, ought to be clear even to
people not very familiar with USB.  Something more like this would be a
lot better:

	Prevent the system from going into automatic suspend while
	it is attached as a USB peripheral.

Alan Stern

