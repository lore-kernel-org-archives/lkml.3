Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3BOQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:40:31 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:57134 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3BOQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130215135141.1EFCEE0085@blue.fi.intel.com>
References: <20130215112911.68A98E0085@blue.fi.intel.com>
	<CANq1E4T1QzOUOwWPpV6_55hVTXzXF4baShxpYaM0HNAgF0ffAg@mail.gmail.com>
	<20130215120022.GA23694@x220>
	<20130215135141.1EFCEE0085@blue.fi.intel.com>
Date: Fri, 15 Feb 2013 18:40:27 +0200
Message-ID: <CAHp75VdC7JnoYwnKRsyr7v3or167OdX8mrv00VK-0YuPhpSFaw@mail.gmail.com>
Subject: Re: uhid: broken interface: 32/64-bit compatibility
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>, linux-api@vger.kernel.org,
        linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        RavindranathX Doddi <ravindranathx.doddi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any comments?

Generic comments.  Could you use *_compat instead of  *_old_*?
Another idea is do not touch current interface, just append new
function and associated structure to make a smooth transition of the
userspace stuff.

What about documentation (Documentation/hid/uhid.txt)? Could you
update it acordingly?

> Subject: [PATCH] uhid: introduce new create event to fix 32/64-bit
>  compatibility issue
>
> Current create event has pointer in payload. It causes problem with
> 32/64-bit compatibility. In particular it's not possible to use 32-bit
> userspace driver with 64-bit kernel.


> This patch deprecates old create event and introduce a new one. The new
> create event has padding for pointer on 32-bit system to extend pointer
> correctly.
>
> Old userspace driver binaries will use old create event. It requires
> simple recompile to switch to new one.

That's what I afraid of. Better to try to avoid any excessive
requirement to the existing userspace.

-- 
With Best Regards,
Andy Shevchenko
