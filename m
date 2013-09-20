Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3ITR6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:58:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab3ITR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:58:49 -0400
Date: Fri, 20 Sep 2013 13:58:40 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kconfig/menu.c: fix uninitialized variable warning
Message-ID: <20130920175840.GA31609@d2.synalogic.ca>
References: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com>
 <20130919152227.GB19364@d2.synalogic.ca>
 <20130919172751.GA3317@free.fr>
 <20130919191315.GA19703@d2.synalogic.ca>
 <20130919200430.GC3317@free.fr>
 <523BB48F.9020403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523BB48F.9020403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/09/20 08:05, Madhavan Srinivasan wrote:
> On Friday 20 September 2013 01:34 AM, Yann E. MORIN wrote:
> > Benjamin, All,
> > 
> > On 2013-09-19 15:13 -0400, Benjamin Poirier spake thusly:
> >> On 2013/09/19 19:27, Yann E. MORIN wrote:
> >>> Benjamin, Madhavan, All,
> >>>
> >>> On 2013-09-19 11:22 -0400, Benjamin Poirier spake thusly:
> >>>> On 2013/09/19 12:58, Madhavan Srinivasan wrote:
> >>>>> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> >>>>> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> >>>>> scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
> >>>>> this function [-Wmaybe-uninitialized]
[...]
> >>>>
> >>>> I do not see this warning with gcc 4.7.2 or 4.8.1. Which version are you
> >>>> using?
> >>>>
[...]
> > 
> > No, I was not able to reproduce it with either gcc-4.4.7, gcc-4.6.4 or
> > gcc-4.7.3 on my Ubuntu 13.04. Neither gcc-4.5 nor 4.8 are packaged, so
> > I could not test them.
> > 
> > Anyway, -Wmaybe-uninitialized is new with 4.7. So, the warning can't
> > happen with gcc < 4.7.
> > 
> > Madhavan, what gcc version are you using?
> gcc i have is gcc version 4.8.0 20130526

In that case, I don't have a strong opinion whether the patch should be
merged or not, but if it is merged, I think a comment should be added to
the code or the changelog stating that this is to work around a
deficiency observed in gcc 4.8.0.
