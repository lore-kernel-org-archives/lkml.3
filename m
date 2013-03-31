Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3CaXEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:04:13 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44146 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3CaXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:04:12 -0400
Date: Sun, 31 Mar 2013 16:04:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 08/11 V5] mei: nfc: Initial nfc implementation
Message-ID: <20130331230408.GA19134@kroah.com>
References: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
 <1364398203-11159-9-git-send-email-tomas.winkler@intel.com>
 <20130329154823.GA21990@kroah.com>
 <20130331224949.GA13814@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130331224949.GA13814@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 12:49:49AM +0200, Samuel Ortiz wrote:
> Hi Greg,
> 
> On Fri, Mar 29, 2013 at 08:48:23AM -0700, Greg KH wrote:
> > On Wed, Mar 27, 2013 at 05:30:00PM +0200, Tomas Winkler wrote:
> > > --- /dev/null
> > > +++ b/drivers/misc/mei/nfc.h
> > > @@ -0,0 +1,122 @@
> > > +/******************************************************************************
> > > + * Intel Management Engine Interface (Intel MEI) Linux driver
> > > + * Intel MEI Interface Header
> > > + *
> > > + * This file is provided under a dual BSD/GPLv2 license.  When using or
> > > + * redistributing this file, you may do so under either license.
> > > + *
> > > + * GPL LICENSE SUMMARY
> > > + *
> > > + * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of version 2 of the GNU General Public License as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful, but
> > > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > > + * General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write to the Free Software
> > > + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
> > > + * USA
> > > + *
> > > + * The full GNU General Public License is included in this distribution
> > > + * in the file called LICENSE.GPL.
> > > + *
> > > + * Contact Information:
> > > + *	Intel Corporation.
> > > + *	linux-mei@linux.intel.com
> > > + *	http://www.intel.com
> > > + *
> > > + * BSD LICENSE
> > > + *
> > > + * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
> > > + * All rights reserved.
> > > + *
> > > + * Redistribution and use in source and binary forms, with or without
> > > + * modification, are permitted provided that the following conditions
> > > + * are met:
> > > + *
> > > + *  * Redistributions of source code must retain the above copyright
> > > + *    notice, this list of conditions and the following disclaimer.
> > > + *  * Redistributions in binary form must reproduce the above copyright
> > > + *    notice, this list of conditions and the following disclaimer in
> > > + *    the documentation and/or other materials provided with the
> > > + *    distribution.
> > > + *  * Neither the name Intel Corporation nor the names of its
> > > + *    contributors may be used to endorse or promote products derived
> > > + *    from this software without specific prior written permission.
> > > + *
> > > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > > + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> > > + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> > > + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> > > + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> > > + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> > > + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> > > + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> > > + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> > > + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> > > + *
> > > + *****************************************************************************/
> > 
> > How is your .h file dual licensed, and yet, the .c file is gpl2 only?
> > 
> > Please fix this by not even having this .h file, it's not needed.
> The structures and commands defined in nfc.h may be used by pure userspace NFC
> stacks (e.g. the Android ones) and I don't want them to be defined under a GPL
> only license (Even though some will say structure and command definitions are
> not copyrighteable).

The law says that structures and command definitions are not
copyrightable, Oracle hasn't overturned that one yet.  That explains how
the BSDs now have the kobject api taken from Linux with no issues at
all.

> Would it be fine with you if I'd put those definitions under
> include/uapi/linux/mei.h ?

No, just put them in the driver itself, there is no need for them to be
in a .h file at all.

thanks,

greg k-h
