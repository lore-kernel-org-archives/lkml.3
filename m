Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199Ab3DJRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:25:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956Ab3DJRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:25:55 -0400
Date: Wed, 10 Apr 2013 10:25:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Message-ID: <20130410172551.GA1881@kroah.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <1365464495-17642-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365464495-17642-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:41:33AM +0300, Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> NFC ME device is exported through the MEI bus to be consumed by the
> NFC subsystem.
> 
> NFC is represented by two mei clients: An info one and the actual
> NFC one. In order to properly build the ME id we first need to retrieve
> the firmware information from the info client and then disconnect from it.

I still don't understand why you aren't tieing this into the existing
nfc kernel api.  What am I missing?

> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/Makefile     |   1 +
>  drivers/misc/mei/client.c     |   3 +
>  drivers/misc/mei/init.c       |   2 +
>  drivers/misc/mei/mei_dev.h    |  10 ++
>  drivers/misc/mei/nfc.c        | 250 ++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild     |   1 +
>  include/uapi/linux/mei/Kbuild |   2 +
>  include/uapi/linux/mei/nfc.h  | 135 +++++++++++++++++++++++

Based on our previous off-list emails, you said that this .h file is
needed for the userspace api.  But the nfc userspace api is through the
nfc API, which doesn't use any of the structures defined here.  So who
exactly uses this file?

confused,

greg k-h
