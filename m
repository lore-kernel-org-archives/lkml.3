Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003Ab3DCP11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:27:27 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36455 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760759Ab3DCP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:27:23 -0400
Date: Wed, 3 Apr 2013 08:27:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is
 NULL
Message-ID: <20130403152720.GA21643@kroah.com>
References: <20130402221104.163133110@linuxfoundation.org>
 <20130402221116.307254752@linuxfoundation.org>
 <87vc833kpf.fsf@turtle.gmx.de>
 <1364997630.13853.19.camel@edumazet-glaptop>
 <87a9pfzm33.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9pfzm33.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:10:40PM +0200, Sven Joachim wrote:
> On 2013-04-03 16:00 +0200, Eric Dumazet wrote:
> 
> > On Wed, 2013-04-03 at 13:41 +0200, Sven Joachim wrote:
> >> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> >> 
> >> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> >> 
> >> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> >> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
> >> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> >> here, and 65534 is the uid of user "nobody".
> >
> > And if you use a 3.1 kernel (before commit
> > 16e5726269611b71c930054ffe9b858c1cea88eb) are you seeing this message ?
> 
> No (tested with 3.1.10).
> 
> > It might be a wrong sender (application bug or bad identity), and udevd
> > correctly discards the incoming message.
> 
> How would I find out the culprit?

Try running 'udevadm monitor' as root and see if something shows up
there.

I can't reproduce this here, running a newer version of udev (195),
sorry, I don't have any systems with older udev releases.

Note, someone else posted this same error earlier today on the linux-usb
mailing list, saying that USB storage devices would not automount
anymore.  Does that work properly for you?

thanks,

greg k-h
