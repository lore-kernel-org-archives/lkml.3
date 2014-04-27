Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaD0Rjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:39:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaD0Rjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:39:52 -0400
Date: Sun, 27 Apr 2014 20:39:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: tiwai@suse.de, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Laurent Navet <laurent.navet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140427173932.GP26890@mwanda>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426215945.GC17562@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 11:59:46PM +0200, Mateusz Guzik wrote:
> > And sadly enough some of those ->id strings are more than 15 characters
> > and a NUL which will fit in card->id.  So this overflow is real.  The
> > card->shortname is a 32 char array so none of those overflow.
> > 
> > If we want to sovle the truncation issue then we need to think of
> > shorter names for BassPODxtLive, BassPODxtPro, PODStudioUX1, and
> > PODStudioUX2.
> > 
> 
> In that case I suggest compile time assertions that ids and names fit

That sounds like some magic code which I would love to see.  :)

>  and a WARN_ON + -EINVAL in line6_init_audio to catch future
>  offenders.

Returning -EINVAL is a bad idea because it would break the driver
completely and make it unusable.

> 
> As a side note I'm not sure if pod_try_init from drivers/staging/line6/pod.c
> cleans up properly after failed line6_init_audio.

Yeah.  It doesn't seem to clean up at all.

regards,
dan carpenter

