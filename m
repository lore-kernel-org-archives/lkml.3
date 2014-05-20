Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaETBJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:09:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETBJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:09:23 -0400
Date: Tue, 20 May 2014 10:09:21 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        "Romer, Benjamin M" <Benjamin.Romer@unisys.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] staging: unisys: move uislib/platform proc entry to
 debugfs
Message-ID: <20140520010921.GA27462@kroah.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
 <1399912715-16142-3-git-send-email-benjamin.romer@unisys.com>
 <20140518164918.GA10285@kroah.com>
 <C97001BC43954D438ACB059713BA5CDFA47DDAD93D@USEA-EXCH7.na.uis.unisys.com>
 <20140519195708.GY15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519195708.GY15585@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:57:08PM +0300, Dan Carpenter wrote:
> On Mon, May 19, 2014 at 09:42:22AM -0500, Romer, Benjamin M wrote:
> > On Sun, 2014-05-18 at 09:49 -0700, Greg KH wrote:
> > > Also, why are these entries moving to debugfs at all?  Why are they
> > > needed?  Who will use them?  Are tools relying on them to be there?
> > 
> > The tuning entries are sometimes used to help adjust the behavior of our
> > IO service partitions for better performance.
> 
> That sounds like it really belongs in sysfs instead of debugfs.

Exactly.  debugfs files are for "debugging".  Consider them files that
your driver can work properly if no one ever touches them.

"tuning" files imply something that has to be touched by users.
Ideally, you would never need such a thing as no one wants to have to
write things to files to make the kernel work better.  But if you really
need it, they should be sysfs files, with the needed documentation.

thanks,

greg k-h
