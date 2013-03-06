Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3CFWcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:32:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40138 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CFWcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:32:41 -0500
Message-ID: <5137C404.9060902@wwwdotorg.org>
Date: Wed, 06 Mar 2013 15:32:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        torvalds@linux-foundation.org
Subject: Re: 3.9-rc1 regression in arm dtb build
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
In-Reply-To: <20130306193332.GA6022@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:33 PM, Pavel Machek wrote:
> Hi!
> 
> Commit
> 
> commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
> Author: Grant Likely <grant.likely@secretlab.ca>
> Date:   Tue Nov 27 16:29:11 2012 -0700
> 
>     The current rules have the .dtb files build in a different
>     directory
>     from the .dts files. The only reason for this is that it was what
>     PowerPC has done historically. This patch changes ARM to use the
> generic dtb rule which builds .dtb files in the same directory as the
> source .dts.
> 
> --
> 
> Moves dtb files from arch/arm/boot/ to arch/arm/boot/dtb. That causes
> several problems:
> 
> 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
> 3.8 tricky

It's pretty easy to locate the DTB by automatically looking in
arch/*/boot/dts first, then if the file doesn't exist there, looking in
arch/*/boot instead as a legacy fallback.

> 2) what is worse, it is very easy to do stuff like
> 
>    make socfpga_cyclone5.dtb
> 
>    and you end up with success, but stale file in arch/arm/boot, where
>    your scripts expect it.
> 
>    (There are some attempts to rm stale files in Makefiles; they don't
>    work in above case).

I guess moving the rm into cmd_dtc rather than the "dtbs" rule would
solve that.

> 3) it is now incosistent between powerpc and arm.

True. PPC's DTB-handling is a little more complex than most, so wasn't
converted along with this patch. It'd be nice to finish the conversion
and make PPC pick up this change too.

> 4) device tree _binary_ files are now output in device tree _source_
> directory

Isn't that true for almost all object files? One of the motivators for
the move was that binaries were being built in a different directory to
the source, which is quite odd.

> (Sorry for noticing this earlier).
> 
> I believe the commit should be simply reverted. Reasons to move dtbs
> around are not good enough.
> 									Pavel
> 

