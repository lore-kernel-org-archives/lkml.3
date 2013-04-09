Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936652Ab3DIAIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:08:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62609 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934888Ab3DIAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:08:17 -0400
Date: Mon, 8 Apr 2013 17:08:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 0/3 V6] Support NFC Device on MEI CL Bus
Message-ID: <20130409000815.GA30420@kroah.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:41:32AM +0300, Tomas Winkler wrote:
> v5 -> v6
>  1. include/linux/uapi/mei/nfc.h - provides API also for pure
>     user space implementation as found under Android.
>  2. Removed INTEL_MEI_BUS_NFC Kconfig option. 
>     The NFC info client is disconnected as soon as we
>     get the FW info and the regular client is connected only when
>     mei_cl_enable_device() is explicitly called from an nfc driver.
>     The mei cl bus now doesn't connect NFC  exclusively.
>  3. Added pn544 to the possibly detected NFC chipsets.
> 
> Depends on: 
> 	mei: bus: Add device enabling and disabling API

If this is a nfc device, why isn't it using the nfc_register_device()
and nfc_unregister_device() calls?  Shouldn't you be using the in-kernel
nfc api we already have?

thanks,

greg k-h
