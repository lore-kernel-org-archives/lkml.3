Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbbA1UrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:18 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59039 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbbA1UrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:11 -0500
Date: Wed, 28 Jan 2015 19:06:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.12 140/176] gpio: sysfs: fix gpio device-attribute leak
Message-ID: <20150128180654.GF2433@localhost>
References: <cover.1422455352.git.jslaby@suse.cz>
 <e66a96f38a5a35c96eadcabbe20921ad32ed087a.1422455352.git.jslaby@suse.cz>
 <20150128161007.GC2433@localhost>
 <54C92072.9080404@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C92072.9080404@suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:46:26PM +0100, Jiri Slaby wrote:
> On 01/28/2015, 05:10 PM, Johan Hovold wrote:
> > On Wed, Jan 28, 2015 at 03:29:30PM +0100, Jiri Slaby wrote:
> >> From: Johan Hovold <johan@kernel.org>
> >>
> >> 3.12-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> ===============
> >>
> >> commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.
> >>
> >> The gpio device attributes were never destroyed when the gpio was
> >> unexported (or on export failures).
> >>
> >> Use device_create_with_groups() to create the default device attributes
> >> of the gpio class device. Note that this also fixes the
> >> attribute-creation race with userspace for these attributes.
> >>
> >> Remove contingent attributes in export error path and on unexport.
> >>
> >> Fixes: d8f388d8dc8d ("gpio: sysfs interface")
> >> Signed-off-by: Johan Hovold <johan@kernel.org>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > 
> > There was a mistake in the 3.14 (and 3.12) backport. A fixed v2 backport
> > has been posted in this thread:
> > 
> > 	https://marc.info/?l=linux-kernel&m=142241055931689&w=2
> 
> But there is no thread. Could you repost?

Just hasn't shown up in the archives yet.

You can find it in the stable queue:

	https://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tree/queue-3.14/gpio-sysfs-fix-gpio-device-attribute-leak.patch

Johan
