Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862Ab3IDOHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:07:17 -0400
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:54654 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3IDOHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:07:12 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 10:07:12 EDT
Date: Wed, 4 Sep 2013 15:57:41 +0200
From: Martin Mares <mj@ucw.cz>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb
 support
Message-ID: <mj+md-20130904.134928.12262.nikam@ucw.cz>
References: <1378302428-19758-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378302428-19758-1-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

First of all: Sorry for not replying to the first mail. I do not follow
linux-pci too much these days (or, I do that in big batches).

> This lets you select hwdb support at compile time.
> 
> hwdb is an efficient hardware database shipped with recent versions of udev.
> It contains among other sources pci.ids so querying hwdb rather than reading
> pci.ids directly should give the same result.
> 
> Ideally Linux distros using udev could stop shipping pci.ids, but use hwdb
> as the only source of this information, which this patch allows.

Generally, I will be glad to include hwdb support in libpci.

There is a couple of details I am concerned with:

> +	if [ -f /usr/include/libudev.h -o -f /usr/local/include/libudev.h ] ; then
> +		HWDB=yes
> +	else
> +		HWDB=no
> +	fi

Does this make sense? Does every version of libudev support hwdb?

> @@ -86,8 +91,58 @@ char
>  *pci_id_lookup(struct pci_access *a, int flags, int cat, int id1, int id2, int id3, int id4)
>  {
>    struct id_entry *n, *best;
> -  u32 id12 = id_pair(id1, id2);
> -  u32 id34 = id_pair(id3, id4);
> +  u32 id12, id34;
> +
> +#ifdef PCI_HAVE_HWDB
> +  if (!(flags & PCI_LOOKUP_SKIP_LOCAL))
> +    {

As you wrote it, hwdb has always priority over pci.ids (unless local lookup is
disabled). As a user, I would expect that pci.ids (being a part of the pciutils)
is the primary source of data and other sources (network lookups, hwdb) are
used only if pci.ids do not match or if explicitly requested.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Quidquid latine dictum sit, altum videtur.
