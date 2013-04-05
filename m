Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162006Ab3DEQYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:24:06 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34943 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161938Ab3DEQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:24:04 -0400
Date: Fri, 5 Apr 2013 09:24:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: svenjoac@gmx.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dingtianhong@huawei.com, edumazet@google.com
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is
 NULL
Message-ID: <20130405162400.GA21473@kroah.com>
References: <20130402221104.163133110@linuxfoundation.org>
 <20130402221116.307254752@linuxfoundation.org>
 <87vc833kpf.fsf@turtle.gmx.de>
 <20130405.004715.1638901359632228839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405.004715.1638901359632228839.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 12:47:15AM -0400, David Miller wrote:
> From: Sven Joachim <svenjoac@gmx.de>
> Date: Wed, 03 Apr 2013 13:41:32 +0200
> 
> > On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> > 
> >> 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> > 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> > patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> > here, and 65534 is the uid of user "nobody".
> 
> Greg and Ben, please stop this patch from all of the -stable trees.

Now dropped from the 3.4.x and 3.8.x -stable trees (it wasn't part of
the 3.0.x network patches that I can tell).

> I'm going to revert it and use Eric Biederman's fix instead.

That seems better, breaking older versions of udev, while fun at times,
did seem to annoy a bunch of Ubuntu and Debian users :)

thanks,

greg k-h
