Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3FFSqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:46:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FFSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:46:33 -0400
Date: Thu, 6 Jun 2013 11:46:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc 3.10] mei: nfc: fix nfc device freeing
Message-ID: <20130606184632.GA7475@kroah.com>
References: <1370240910-16411-1-git-send-email-tomas.winkler@intel.com>
 <20130603142654.GD7024@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B028BCE64@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B028BCE64@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 07:57:24AM +0000, Winkler, Tomas wrote:
> 
> > 
> > On Mon, Jun 03, 2013 at 09:28:30AM +0300, Tomas Winkler wrote:
> > > The nfc_dev is a static variable and is not cleaned properly upon
> > > reset mainly ndev->cl and ndev->cl_info are not set to NULL after
> > > freeing which
> > 
> > Then it needs to be made dynamic, don't paper over the bug by zeroing it
> > out, you really have a much larger issue here that just hasn't hit you yet.
> > 
> > No 'struct device' should ever be in a static variable, please fix this properly.
> 
> Greg,  I was looking into it and as in realistic configuration is we
> are fine as there is only one possible MEI NFC device on whole system.
> nfc_dev is also not 'a struct device' type is a singleton then holds NFC configuration.

Ah, you are right, my mistake, I would have expected something that
ended with _dev to be a device :)

> Currently changing the behavior would require rather a larger fix and
> this oneliner  effectively fixes the crash.
> 
> I don't mind to fix it properly but we are already in rc3, let us know
> what path to go. 

Can you resend this so I can apply it?

thanks,

greg k-h
