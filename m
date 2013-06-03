Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab3FCO02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:26:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3FCO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:26:25 -0400
Date: Mon, 3 Jun 2013 07:26:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc 3.10] mei: nfc: fix nfc device freeing
Message-ID: <20130603142654.GD7024@kroah.com>
References: <1370240910-16411-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370240910-16411-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 09:28:30AM +0300, Tomas Winkler wrote:
> The nfc_dev is a static variable and is not cleaned properly upon reset
> mainly ndev->cl and ndev->cl_info are not set to NULL after freeing which

Then it needs to be made dynamic, don't paper over the bug by zeroing it
out, you really have a much larger issue here that just hasn't hit you
yet.

No 'struct device' should ever be in a static variable, please fix this
properly.

thanks,

greg k-h
