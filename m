Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaKRRNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:13:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaKRRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:13:53 -0500
Date: Mon, 17 Nov 2014 16:55:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: mdc: use __FMODE_EXEC macro
Message-ID: <20141118005521.GA11927@kroah.com>
References: <1416263028-16026-1-git-send-email-juston.h.li@gmail.com>
 <20141117224616.GI4905@mwanda>
 <1416270188.18197.16.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416270188.18197.16.camel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 04:23:08PM -0800, Juston wrote:
> On Tue, 2014-11-18 at 01:46 +0300, Dan Carpenter wrote:
> > On Mon, Nov 17, 2014 at 02:23:48PM -0800, Juston Li wrote:
> > > FMODE_EXEC is type fmode_t but is used in operations
> > > with integers which leads to sparse warnings:
> > > drivers/staging/lustre/lustre/mdc/mdc_lib.c:198:21: warning: restricted fmode_t degrades to integer
> > > drivers/staging/lustre/lustre/mdc/mdc_locks.c:300:49: warning: restricted fmode_t degrades to integer
> > > 
> > > Fix by using __FMODE_EXEC macro defined in fs.h.
> > > 
> > > Note the same warnings occurs with other fmode flags
> > > here but they don't have a corresponding int macro.
> > > 
> > 
> > When are FMODE_EXEC and __FMODE_EXEC not defined?  I think they're
> > always defined.  I don't understand the point of these ifdefs.  I guess
> > maybe they are for compatability with obsolete kernels?
> > 
> > regards,
> > dan carpenter
> > 
> Seems to be the case. Looked at some old commits (2.6.17) and found
> FMODE_EXEC was mainlined to allow lustre to be installed on a vanilla
> kernel.
> Since you pointed it out, if we are dealing with compatability with 
> obselete kernels, __FMODE_EXEC was added later in 2.6.38. Wondering
> if I should address the case where FMODE_EXEC is defined but 
> __FMODE_EXEC isn't since I currently only check __FMODE_EXEC.

Just fix it up to work the the current kernel version, no need to
support anything else in this codebase.

thanks,

greg k-h
