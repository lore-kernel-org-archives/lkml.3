Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3FNUj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3FNUj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:39:56 -0400
Date: Fri, 14 Jun 2013 13:40:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, joe@perches.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH v2] power: Include additional information in
 pm_print_times
Message-ID: <20130614204032.GA2912@kroah.com>
References: <1371242124-11452-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371242124-11452-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 02:35:24PM -0600, Shuah Khan wrote:
> Change __device_suspend() path to include driver name and the ops that
> get run for a device. This additional information helps associate the
> driver and the type of pm_ops the device uses in the suspend path very
> quickly which will aid in debugging problems in suspend and resume paths.
> Changed both start and end debug messages to include pm_ops information
> and use dev_info() instead of pr_info().
> 
> dmesg output before the change:
> 
> [  164.390032] calling  1-1+ @ 69, parent: usb1
> [  164.390035] call 1-1+ returned 0 after 0 usecs
> 
> [  164.390352] calling  00:0a+ @ 2457, parent: pnp0
> [  164.390357] call 00:0a+ returned 0 after 3 usecs
> 
> [  164.390361] calling  00:09+ @ 2457, parent: pnp0
> [  164.496458] call 00:09+ returned 0 after 103500 usecs
> 
> [  164.496494] calling  00:05+ @ 2457, parent: pnp0
> [  164.496511] call 00:05+ returned 0 after 14 usecs
> 
> dmesg output after the change:
> 
> [   58.707002] usb usb1: calling type pm ops @ 57, parent: 0000:00:1d.0
> [   58.707641] usb usb1: call type pm ops returned 0 after 611 usecs
> 
> [   58.702014] system 00:0a: calling legacy bus pm ops @ 2173, parent: pnp0
> [   58.702018] system 00:0a: call legacy bus pm ops returned 0 after 2 usecs
> 
> [   58.702023] tpm_tis 00:09: calling legacy bus pm ops @ 2173, parent: pnp0
> [   58.806909] tpm_tis 00:09: call legacy bus pm ops returned 0 after 102425 usecs
> 
> [   58.806927] rtc_cmos 00:05: calling legacy bus pm ops @ 2173, parent: pnp0
> [   58.806935] rtc_cmos 00:05: call legacy bus pm ops returned 0 after 5 usecs
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/power/main.c |   44 +++++++++++++++++++++++++-------------------
>  1 file changed, 25 insertions(+), 19 deletions(-)

I'm assuming this will go through Rafael's tree:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
