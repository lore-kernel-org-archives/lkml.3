Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3JBQr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:47:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41761 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3JBQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:47:25 -0400
Date: Wed, 2 Oct 2013 09:47:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131002164718.GA7392@roeck-us.net>
References: <20130927175926.GA6267@roeck-us.net>
 <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com>
 <524615B1.6000106@roeck-us.net>
 <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com>
 <524A4384.4040403@roeck-us.net>
 <20131002035156.GA566@roeck-us.net>
 <20131002095339.GA2716@polaris.bitmath.org>
 <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002163418.GA4557@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 06:34:18PM +0200, Henrik Rydberg wrote:
> > >>One thing I have seen in all logs is the earlier "send_byte fail" message, so
> > >>I think that is a pre-requisite.
> > >
> > >Not necessarily - it could be that the patch actually fixes the root
> > >cause. One possible scenario is that on recent SMCs, some of the
> > >commands produce more data than we actually read. This would
> > >eventually lead to both data corruption and overflow somwhere in the
> > >SMC internals.  If the original SMC error is interpreted as a read
> > >buffer overflow, then that problem should be fixed with this patch.
> > >
> > 
> > Good point.
> > 
> > But shouldn't we at least get the "flushed %d bytes" warning message in this case ?
> 
> The explanation I have there is that the (newer) SMC needs the
> application to read the 'no more bytes' or it will get confused. It
> makes sense, if the number of bytes to read is no longer specified.
> 
You mean that just reading from APPLESMC_CMD_PORT would solve the problem ?
That might make sense.

Thanks,
Guenter
