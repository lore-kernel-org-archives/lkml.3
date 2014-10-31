Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422833AbaJaCNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:13:38 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:39102 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422665AbaJaCNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:13:34 -0400
Date: Fri, 31 Oct 2014 11:12:55 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: collect shorthands into the top Makefile
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20141029185907.GA701@ravnborg.org>
References: <1414567651-2503-1-git-send-email-yamada.m@jp.panasonic.com> <20141029185907.GA701@ravnborg.org>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141031111254.8FF3.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Wed, 29 Oct 2014 19:59:07 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Oct 29, 2014 at 04:27:31PM +0900, Masahiro Yamada wrote:
> > The motivation of this commit is to avoid duplicated definitions
> > of "clean" and "hdr-inst" shorthands.
> > 
> > The shorthand "clean" is defined in both the top Makefile and
> > scripts/Makefile.clean.
> > 
> > Likewise, "hdr-inst" is defined in both the top Makefile and
> > scripts/Makefile.headersinst.
> > 
> > The idea here is define and export them in the top Makefile
> > because $(srctree) is constant during the build process.
> > 
> > For consistency, "build" and "modbuiltin" should be also moved.
> 
> As a general rule the exported names are always UPPERCASE, and local variables
> are lowercase. (srctree, objtree are the exceptions).
> This patch define new lowercase variables that conflicts with this.
> 
> And it is not that logical these are picked up from the enviroment.
> Could you find a central place to define them rahter than using
> the environemnt to export them?

Maybe we can collect them into scripts/Kbuild.include
although it might be too much for Makefile.clean to include
the whole things in Kbuild.include.


Best Regards
Masahiro Yamada

