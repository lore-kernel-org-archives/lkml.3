Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3I3Bkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3I3Bke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:40:34 -0400
Date: Sun, 29 Sep 2013 21:40:09 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Bastian Blank <waldi@debian.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq: Allow access to sensitive keys to be restricted
 by default
Message-ID: <20130930014009.GA30635@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>, Bastian Blank <waldi@debian.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1380504668.14493.22.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380504668.14493.22.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 02:31:08AM +0100, Ben Hutchings wrote:
 > From: Bastian Blank <waldi@debian.org>
 > 
 > Add a Kconfig variable to set the initial value of the Magic SysRq mask
 > (sysctl: kernel.sysrq).
 > 
 > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
 > ---
 > This has been in Debian for a while, but should probably be signed-off
 > by Bastian as well.
 > 
 > Debian sets this to 0x01b6, which excludes.
 > 
 >           8 - enable debugging dumps of processes etc.
 >          64 - enable signalling of processes (term, kill, oom-kill)
 > ...
 >  
 > +config MAGIC_SYSRQ_DEFAULT_MASK
 > +	hex "Default mask for Magic SysRq keys on the console"
 > +	depends on MAGIC_SYSRQ
 > +	default 1
 > +	help
 > +	  Specifies the default mask for the allowed SysRq keys.  This can be
 > +	  used to disable several sensitive keys by default.

Might be nice to have the mask values duplicated here to save having to
go grepping through code ?

	Dave

