Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaAaQB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:01:26 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:30187 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaAaQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:01:24 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 11:01:24 EST
Message-ID: <52EBC78D.9060805@tilera.com>
Date: Fri, 31 Jan 2014 10:55:57 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: remove compat_sys_lookup_dcookie declaration to
 fix compile error
References: <20140131065036.GB4114@osiris>
In-Reply-To: <20140131065036.GB4114@osiris>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/2014 1:50 AM, Heiko Carstens wrote:
> With d8d14bd09cdd "fs/compat: fix lookup_dcookie() parameter handling" I
> changed the type of the len parameter of the lookup_dcookie() syscall.
>
> However I missed that there was still a stale declaration in arch/tile/..
> which now causes a compile error on tile:
>
> In file included from fs/dcookies.c:28:0:
> include/linux/compat.h:425:17: error: conflicting types for 'compat_sys_lookup_dcookie'
> fs/dcookies.c:207:1: error: conflicting types for 'compat_sys_lookup_dcookie'
>
> Simply remove the declaration in the tile architecture, which is only a
> leftover from before the different compat lookup_dcookie() versions have
> been merged.
> The declaration is now in include/linux/compat.h
>
> The build error was reported by Fenguang's build bot.
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

