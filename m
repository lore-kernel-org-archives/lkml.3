Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3D0VBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 17:01:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3D0VBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 17:01:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: Re: [PATCH 6/8] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Sat, 27 Apr 2013 23:01:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Greg KH <greg@kroah.com>
References: <cover.1366841993.git.yann.morin.1998@free.fr> <6079984.JVoK3fHgsy@wuerfel> <20130426220912.GD5100@free.fr>
In-Reply-To: <20130426220912.GD5100@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304272301.00587.arnd@arndb.de>
X-Provags-ID: V02:K0:BwJIMGvjZQk2ugpsgHKNcZRvCxUzMaeMU3BjGB3f4un
 SyyPsBzEnmxeGNB5Mj+9IJPN83eqBQld9/w4VO0EbcZp4NthBo
 yKJ15sn51lFSqKNM28kbHGCDogzmzFOO36HueSQzXIFE3MGmEX
 3gt13yHuNG1r3HQXKGEUaQYpZ5uK8zC6iy2EnWnPNg+22y2Xpq
 QJgBaU5KeTSFN9mtUyCf0bcSce9IroJqFIV2XeplF01dCRUJAm
 xup09hUZBwonxaqNSI7CjgJFugrGe1PqVoBQqvZC5kz3ls9Sxp
 NZA4+GejC97jQNyx19n90MBDHhBcSOUwewa5WvwfzlHyKye7SK
 zdTWLfKEoC62pP2hElq0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 April 2013, Yann E. MORIN wrote:
> 
> On Fri, Apr 26, 2013 at 02:05:37PM +0200, Arnd Bergmann wrote:
> > On Thursday 25 April 2013 00:29:53 Yann E. MORIN wrote:
> > > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > > 
> > > Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> > > is specified.
> > > 
> > > For example, given those two files (Thomas' test-case):
> > 
> > This patch has made it into linux-next today, and while I agree with
> > the basic idea, it seems to cause regressions for me.
> > 
> > For these ARM defconfigs, 'make' always asks about USB_GADGET now
> 
> OK, I threw in the towel on that one for tonight.
> I'll send a patch to revert this changeset, in the coming minutes.
> 
> It will have to be revisited later on, and hopefully we can come to a
> proper solution during the pre-rc1 window, or at worst, early during the
> -rc phase (as I'm on holidays the next two weeks, I should find sometime
> to gather what remains of my courage to look at that again).

Ok, fair enough. For my own testing, I've actually started relying on the
behavior that is meant to be changed by the patch, even though I realize
that  we should really randomize choice statements.

It's easy enough for me to change my script to always select
CONFIG_ARCH_MUTLIPLATFORM for ARM testing in the future.

	Arnd
