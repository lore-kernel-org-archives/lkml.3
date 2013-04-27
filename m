Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3D0WcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 18:32:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36971 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3D0WcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 18:32:04 -0400
Date: Sun, 28 Apr 2013 00:31:58 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/8] kconfig: fix randomising choice entries in presence
 of KCONFIG_ALLCONFIG
Message-ID: <20130427223158.GA24099@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
 <6079984.JVoK3fHgsy@wuerfel>
 <20130426220912.GD5100@free.fr>
 <201304272301.00587.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304272301.00587.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, All,

On Sat, Apr 27, 2013 at 11:01:00PM +0200, Arnd Bergmann wrote:
> On Saturday 27 April 2013, Yann E. MORIN wrote:
> > 
> > On Fri, Apr 26, 2013 at 02:05:37PM +0200, Arnd Bergmann wrote:
> > > On Thursday 25 April 2013 00:29:53 Yann E. MORIN wrote:
> > > > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > > > 
> > > > Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> > > > is specified.
> > > > 
> > > > For example, given those two files (Thomas' test-case):
> > > 
> > > This patch has made it into linux-next today, and while I agree with
> > > the basic idea, it seems to cause regressions for me.
> > > 
> > > For these ARM defconfigs, 'make' always asks about USB_GADGET now
> > 
> > OK, I threw in the towel on that one for tonight.
> > I'll send a patch to revert this changeset, in the coming minutes.
> > 
> > It will have to be revisited later on, and hopefully we can come to a
> > proper solution during the pre-rc1 window, or at worst, early during the
> > -rc phase (as I'm on holidays the next two weeks, I should find sometime
> > to gather what remains of my courage to look at that again).
> 
> Ok, fair enough. For my own testing, I've actually started relying on the
> behavior that is meant to be changed by the patch, even though I realize
> that  we should really randomize choice statements.
> 
> It's easy enough for me to change my script to always select
> CONFIG_ARCH_MUTLIPLATFORM for ARM testing in the future.

Fact is, choices are properly randomised, unless KCONFIG_ALLCONFIG is
passed.

So, if you currently rely on choices not being randomised, it means
you're using KCONFIG_ALLCONFIG [*] so you can set CONFIG_ARCH_MULTIPLATFORM
in the defconfig you use.

Which should not change your workflow by much, I believe.

[*] If not, then we have another issue. Can you confirm you're already
using KCONFIG_ALLCONFIG? If not, can you explain how you handle
CONFIG_ARCH_MULTIPLATFORM always being set?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
