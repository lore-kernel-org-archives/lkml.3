Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbaD2R3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:29:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37817 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaD2R3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:29:12 -0400
Date: Tue, 29 Apr 2014 20:28:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, Laurent Navet <laurent.navet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140429172858.GD26890@mwanda>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
 <20140427173932.GP26890@mwanda>
 <20140427200042.GA23846@mguzik.redhat.com>
 <20140427224425.GQ26890@mwanda>
 <s5h38gw9or4.wl%tiwai@suse.de>
 <20140429152616.GA2316@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429152616.GA2316@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two options:
1) Do we risk introducing new truncation bugs.
2) Do we risk breaking the driver because we didn't catch every
   truncation bug.

Truncation bugs here are very low impact and probably no one would even
notice.  That's how not worried I am about truncation bugs in this
context.  It's also unlikely that we will introduce any new truncation
bugs.

Breaking the driver is very serious.  But on the other hand as soon as
you proposed introducing an -EINVAL, I reviewed the driver and found the
places which would break when the code was changed.  As a result of my
review then the likely hood of breakage is now low.

In other words both options are probably fine.  If someone is able to
test the -EINVAL change then I would be happy to have it.

regards,
dan carpenter

