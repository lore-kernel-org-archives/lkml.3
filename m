Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaF0EFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:05:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0EFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:05:39 -0400
Date: Thu, 26 Jun 2014 19:25:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 00/13] leds: fix attribute-creation races
Message-ID: <20140626232506.GA26949@kroah.com>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
 <CAK5ve-JVBoeW+a+1PKcfCwNOC+HOdKUD=1iFrTJAZ_tqh10yuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-JVBoeW+a+1PKcfCwNOC+HOdKUD=1iFrTJAZ_tqh10yuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:46:19PM -0700, Bryan Wu wrote:
> On Wed, Jun 25, 2014 at 10:08 AM, Johan Hovold <johan@kernel.org> wrote:
> > LED-class device attributes should be created using the attribute groups
> > of struct device, rather than be added manually after the device has
> > been registered in order to avoid racing with userspace.
> >
> > The first patch adds an attribute groups field to struct led_classdev,
> > which is used during registration to add device attributes in a
> > race-free manner.
> >
> > The remaining patches convert the current racy LED-device attribute
> > creations to use the new facility. Hopefully my grep-patterns have
> > caught most instances. Note that this also tends to simplify probe error
> > paths.
> >
> > The lp55xx-common failed to remove the attribute group it is currently
> > creating, something which is fixed separately.
> >
> > Note that this series include one driver from drivers/input/keyboard.
> >
> > The individual led-driver patches have been compile tested only.
> >
> 
> Thanks a lot for driving this. I will applied this patchset into my
> -devel branch. After I got the Ack from Input guys, I will apply it to
> my for-next branch then.

Series looks good to me, Johan, thanks for doing this work.

greg k-h
