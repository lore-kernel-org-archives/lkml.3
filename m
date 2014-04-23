Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaDWJJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:09:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaDWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:09:20 -0400
Date: Wed, 23 Apr 2014 12:09:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] staging: gdm72xx: Minor cleanup
Message-ID: <20140423090904.GV26890@mwanda>
References: <532BF9B0.2080008@fastmail.fm>
 <20140418225229.GA28077@kroah.com>
 <53534051.2020504@fastmail.fm>
 <53534116.3040705@fastmail.fm>
 <20140422093743.GC26890@mwanda>
 <53570BAA.3080709@fastmail.fm>
 <20140423080447.GS26890@mwanda>
 <53577E96.10106@fastmail.fm>
 <20140423090557.GU26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423090557.GU26890@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:05:57PM +0300, Dan Carpenter wrote:
> On Wed, Apr 23, 2014 at 04:49:26PM +0800, Michalis Pappas wrote:
> > Hi Dan, thanks for looking at this. From the above snippet I realize
> > that I wasn't aware of the strict flag, so significantly less errors
> > were produced.
> > 
> > The issues I was referring to as pedantic are:
> > 
> > WARNING: unchecked sscanf return value
> > #296: FILE: gdm_wimax.c:296:
> > +               sscanf(e->dev->name, "wm%d", &idx);
> > 
> > does this really need to be checked?
> 
> Just check it.  The code as is looks like a information leak (security
> vulnerability) until you realize that e->dev->name is probably a known,
> trusted string.

Btw, we saw a "fix" for this earlier which just printed an error
message.  Don't do that.  Assume that static checkers will soon start
complaining about the info leak instead of just looking at sscanf().

regards,
dan carpenter

