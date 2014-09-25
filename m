Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaIYQoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:44:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38968 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaIYQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:44:52 -0400
Date: Thu, 25 Sep 2014 18:44:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Message-ID: <20140925164446.GD28201@nazgul.tnic>
References: <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU7VO01_qRGc0TV2K+nJJCu4sm0zbH773_zBWdaxSR1aQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:45:29AM +0200, Geert Uytterhoeven wrote:
> Instead of grepping, you can feed the build log to linux-log-summary.
> Or when changing a driver, feed the before and after build logs to
> linux-log-diff. That way you won't miss the single new warning you've
> just introduced.
> 
> https://github.com/geertu/linux-scripts

Yep, nice stuff: linux-log-summary does nicely summarize it all like
this here:

...
include/linux/kernel.h:120:19: warning: cast from function call of type ‘void *’ to non-matching type ‘long unsigned int’ [-Wbad-function-cast]: 40 warnings in 1 logs
include/linux/kernel.h:67:27: warning: conversion to ‘int’ from ‘long unsigned int’ may alter its value [-Wconversion]: 2 warnings in 1 logs
include/linux/kernel.h:67:33: warning: conversion to ‘long unsigned int’ from ‘int’ may change the sign of the result [-Wsign-conversion]: 3 warnings in 1 logs
...

which I ran on a file built with W=123.

So I'd say everything needed is there to massage those build logs.

Thanks.

-- 
Regards/Gruss,
    Boris.
--
