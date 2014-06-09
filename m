Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaFILkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:40:37 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:46081 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaFILkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:40:35 -0400
Date: Mon, 9 Jun 2014 13:40:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [Question] Why CONFIG_SHELL
Message-ID: <20140609114010.GA28767@ravnborg.org>
References: <20140609140411.95B6.AA925319@jp.panasonic.com>
 <20140609074934.GB15826@ravnborg.org>
 <20140609192548.95CA.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609192548.95CA.AA925319@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 07:25:48PM +0900, Masahiro Yamada wrote:
> Hi Sam,
> 
> 
> On Mon, 9 Jun 2014 09:49:35 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Mon, Jun 09, 2014 at 02:04:12PM +0900, Masahiro Yamada wrote:
> > > Hi experts.
> > > 
> > > I think all the macros with CONFIG_ prefix are supposed to be
> > > defined in Kconfig.
> > > But I've been long wondering why there exists one exception:
> > > CONFIG_SHELL.
> > > 
> > > Is there any historical, or special reason?
> > It has been like this as far back as I remmeber.
> > I assume that one has planned to set the shell in Kconfig back then.
> >  
> > > Is it good to rename it to KBUILD_SHELL or something else?
> > Please do so, to free up the CONFIG_ namespace.
> > 
> > I the end Michal will decide if he want this cleanup.
> > On the top of my head I see no problems in doing this,
> > but maybe there are some out-of-tree modules or similar
> > we need to consider...
> 
> Thanks for your commet.
> 
> Another question popped up.
> 
> 
> CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
>           else if [ -x /bin/bash ]; then echo /bin/bash; \
>           else echo sh; fi ; fi)
> 
> 
> If  bash is not found on the system,  CONFIG_SHELL falls back to  "sh".
> 
> Does it mean,  all shell scripts are written as  sh-compatible ?
Not all - but most.
All shell scripts that are invoked with $(CONFIG_SHELL) must be sh-compatible,
or in practice dash compatible as well as bash compatible.
The preference is bash as expressed with the above code.

	Sam
