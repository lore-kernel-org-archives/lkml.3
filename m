Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EMOX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:23:59 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55246 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752065Ab3EMOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:23:57 -0400
Date: Mon, 13 May 2013 00:52:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, LMML <linux-media@vger.kernel.org>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
Message-ID: <20130512215221.GD6748@valkosipuli.retiisi.org.uk>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
 <20130417074300.33d05475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417074300.33d05475@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Apr 17, 2013 at 07:43:00AM -0300, Mauro Carvalho Chehab wrote:
> and a camera anymore. The OMAP2 were used on some Nokia phones.
> They used to maintain that code, but now that they moved to the dark
> side of the moon, they lost their interests on it. So, it may not 
> be easily find testers for patches there.

There's one more underlying issue there than potentially having both no-one
with the device and time to test it: the driver does not function as-is in
mainline (nor any recent non-mainline kernel either). Quite some work would
be required to update it (both to figure out why the whole system crashes
when trying to capture images and change the driver use modern APIs). A
small while back we decided to still keep the driver in the tree:

<URL:http://www.spinics.net/lists/linux-media/msg56237.html>

(The rest of the discussion took place in #v4l AFAIR.)

So, what could be done now is either 1) write a patch that changes the
driver to use the right API and take a risk of adding one more bug to the
driver; or 2) remove the driver now and bring it back only if someone really
has time to make it work first.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
