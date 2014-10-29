Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbaJ2S7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:59:15 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:44077 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaJ2S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:59:14 -0400
Date: Wed, 29 Oct 2014 19:59:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: collect shorthands into the top Makefile
Message-ID: <20141029185907.GA701@ravnborg.org>
References: <1414567651-2503-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414567651-2503-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:27:31PM +0900, Masahiro Yamada wrote:
> The motivation of this commit is to avoid duplicated definitions
> of "clean" and "hdr-inst" shorthands.
> 
> The shorthand "clean" is defined in both the top Makefile and
> scripts/Makefile.clean.
> 
> Likewise, "hdr-inst" is defined in both the top Makefile and
> scripts/Makefile.headersinst.
> 
> The idea here is define and export them in the top Makefile
> because $(srctree) is constant during the build process.
> 
> For consistency, "build" and "modbuiltin" should be also moved.

As a general rule the exported names are always UPPERCASE, and local variables
are lowercase. (srctree, objtree are the exceptions).
This patch define new lowercase variables that conflicts with this.

And it is not that logical these are picked up from the enviroment.
Could you find a central place to define them rahter than using
the environemnt to export them?

	Sam
