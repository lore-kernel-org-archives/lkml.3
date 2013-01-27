Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3A0UVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 15:21:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45460 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3A0UVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 15:21:34 -0500
Date: Sun, 27 Jan 2013 23:19:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] TTY: synclink, small cleanup in dtr_rts()
Message-ID: <20130127201947.GO16282@mwanda>
References: <20130127194039.GA18787@elgon.mountain>
 <1359317078.14406.12.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359317078.14406.12.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 12:04:38PM -0800, Joe Perches wrote:
> On Sun, 2013-01-27 at 22:40 +0300, Dan Carpenter wrote:
> > There is a kind of precedence problem here, but it doesn't affect how
> > the code works because ->serial_signals is unsigned char.  We want to
> > clear two flags here.
> > 
> > #define SerialSignal_RTS            0x20     /* Request to Send */
> > #define SerialSignal_DTR            0x80     /* Data Terminal Ready */
> > 
> > Without the parenthesis then it does:
> > 
> > 	info->serial_signals &= 0x5f;
> > 
> > With the parenthesis it does:
> > 
> > 	info->serial_signals &= 0xffffff5f;
> > 
> > info->serial_signals is an unsigned char so the two statements are
> > equivalent, but it's cleaner to add the parenthesis.  In other dtr_rts()
> > functions the parenthesis are there so this makes it more consistent.
> 
> 
> Wouldn't it be clearer still to use | instead of +
> 

Yeah.  I think it would be, but adding bitflags together instead of
doing bitwise ORs is very common as well.

I would Ack the patch you sent though.

regards,
dan carpenter

