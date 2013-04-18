Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967375Ab3DRQGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:06:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58291 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935970Ab3DRQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:06:39 -0400
Message-ID: <1366301198.2119.14.camel@joe-AO722>
Subject: Re: linux-next: build failure after merge of the usb tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Apr 2013 09:06:38 -0700
In-Reply-To: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
References: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 16:05 +1000, Stephen Rothwell wrote:
> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-usbat.ko] undefined!
[...]
> Caused by commit 75b9130e8af6 ("usb: storage: Add usb_stor_dbg, reduce
> object size").  Please build test such infrastructure patches with and
> without MODULES ...
> 
> I have used the usb tree from next-20130417 for today.

Sorry 'bout that.

I did compilation allyesconfig and allmodconfig with
and without CONFIG_USB_STORAGE_VERBOSE and made
.ko's for that directory only but not a full link.

Looks like it needs EXPORT_SYMBOL_GPL(usb_stor_dbg) in
debug.c.  It takes me quite a while to do a complete
allmodconfig build, but I'll check.


