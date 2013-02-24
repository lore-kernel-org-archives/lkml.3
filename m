Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3BXHzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 02:55:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56769 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3BXHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 02:55:37 -0500
Date: Sat, 23 Feb 2013 23:55:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
Message-ID: <20130224075533.GB18844@core.coreip.homeip.net>
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
 <512851E0.7000808@wwwdotorg.org>
 <1361597308.137178281@f2.mail.ru>
 <512955F7.1020309@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512955F7.1020309@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 04:51:19PM -0700, Stephen Warren wrote:
> On 02/22/2013 10:28 PM, Alexander Shiyan wrote:
> >> On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
> >>> The driver can be used in various subsystems and therefore should not
> >>> be unloaded when it is defined in the kernel configuration, so remove
> >>> support for unloading it.
> >>
> >> Why not fix the clients to module_get() at the appropriate times; then
> >> you could still allow unloading, couldn't you?
> > 
> > I has explain this before.
> 
> If multiple people have asked this, perhaps it'd be a good idea to
> include the answer in the commit description.
> 
> > Driver defined as "bool" and loaded via postcore_initcall.
> 
> Being defined as a "bool" sounds like a reasonable reason that no
> remove() is required.

No, it is not - I can still unbind the device from driver via sysfs. Now
what will happen is resources are leaked and won't be available when
trying to bin (via sysfs) again.

This patch is broken.

Thanks.

-- 
Dmitry
