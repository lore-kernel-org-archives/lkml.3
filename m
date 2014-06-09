Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaFIK0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:26:02 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:34469 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaFIKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:25:58 -0400
Date: Mon, 09 Jun 2014 19:25:48 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Question] Why CONFIG_SHELL
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
In-Reply-To: <20140609074934.GB15826@ravnborg.org>
References: <20140609140411.95B6.AA925319@jp.panasonic.com> <20140609074934.GB15826@ravnborg.org>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140609192548.95CA.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,


On Mon, 9 Jun 2014 09:49:35 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Jun 09, 2014 at 02:04:12PM +0900, Masahiro Yamada wrote:
> > Hi experts.
> > 
> > I think all the macros with CONFIG_ prefix are supposed to be
> > defined in Kconfig.
> > But I've been long wondering why there exists one exception:
> > CONFIG_SHELL.
> > 
> > Is there any historical, or special reason?
> It has been like this as far back as I remmeber.
> I assume that one has planned to set the shell in Kconfig back then.
>  
> > Is it good to rename it to KBUILD_SHELL or something else?
> Please do so, to free up the CONFIG_ namespace.
> 
> I the end Michal will decide if he want this cleanup.
> On the top of my head I see no problems in doing this,
> but maybe there are some out-of-tree modules or similar
> we need to consider...

Thanks for your commet.

Another question popped up.


CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
          else if [ -x /bin/bash ]; then echo /bin/bash; \
          else echo sh; fi ; fi)


If  bash is not found on the system,  CONFIG_SHELL falls back to  "sh".

Does it mean,  all shell scripts are written as  sh-compatible ?

I guess bash is installed on the almost all system.
It is difficult to detect the problem even if some scripts don't work
on sh.


If we allow bash-specific syntax in shell scripts,
we should stop the build immedately if bash is missing,
like this?

KBUILD_SHELL := /bin/bash
if [ ! -x "$$BASH" ]; then
   $(error   $KBUILD_SHELL  not found)
fi




Best Regards
Masahiro Yamada

