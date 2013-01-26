Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3AZJRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 04:17:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3AZJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 04:17:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from regmap_read_debugfs
Date: Sat, 26 Jan 2013 09:17:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-12-git-send-email-arnd@arndb.de> <20130126044219.GA10580@opensource.wolfsonmicro.com>
In-Reply-To: <20130126044219.GA10580@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301260917.28028.arnd@arndb.de>
X-Provags-ID: V02:K0:hoxZ/2UMHF1TNU6RtBcpiqFgAy6yadMXXFjud/3uEPC
 ZBWHJTG0XwsH2aNrieHhINDiuC61UiRsIm1Rq7VPLoryN3c3g7
 UuckAP6TlkkN2iifjyIJMQ2EQkrYksfOCsY6VFNRuFBXLvE3zh
 DOZbhjqO/s6nJ6SqWS4Fp4JIaw1BEcggJ6Ckd0PXyu+NKjtM/J
 MhSX7MdrF490v8AIN4qze6Y3XBcVZbGSofptoKcJCf7YxQ87th
 a32z96APnlI9jvzt6x+95m3GHN3WO3nrIO00cZTVLfNU7e4e3f
 lkWMmSIPX6JUtVUvKg39YrculxLXcUiRbQAVudJZRUiTZVKkdB
 rhSV4GaHhO4urjc5CV4o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2013, Mark Brown wrote:
> On Fri, Jan 25, 2013 at 02:14:28PM +0000, Arnd Bergmann wrote:
> > Gcc warns about the case where regmap_read_debugfs tries
> 
> Are you sure about that function name?

Yes, regmap_read_debugfs uses the return value from
regmap_debugfs_get_dump_start, for which gcc found
a path that returns the uninitialized value.

> > to walk an empty map->debugfs_off_cache list, which results
> > in uninitialized variable getting returned.
> 
> > Setting this variable to 0 first avoids the warning and
> > the potentially undefined value.
> 
> This probably won't apply against current code as there's already a
> better fix there, in general just picking a value to initialise masks
> errors.

I agree on the general rule not to do this, and I'm trying to avoid it
in the cases where I can find a better fix, but here I could not
(mostly because I could not figure out what this code actually
does. Thanks for taking a look.

Which code is the current version? Is your fix headed for 3.8 inclusion?

I still see the warning in 3.8-rc5 as well as yesterday's linux-next,
with gcc-4.6, 4.7 and 4.8-pre.

	Arnd
