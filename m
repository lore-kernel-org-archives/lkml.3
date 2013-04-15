Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3DOCG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:06:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54997 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3DOCG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:06:26 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 14 Apr 2013 19:06:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog: introduce new watchdog AUTOSTART option
Message-ID: <20130415020642.GA29589@roeck-us.net>
References: <A874F61F95741C4A9BA573A70FE3998F82E4BBC2@DQHE02.ent.ti.com>
 <20130412151826.GC28704@roeck-us.net>
 <A874F61F95741C4A9BA573A70FE3998F82E4BD12@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E4BD12@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:43:31AM +0000, Kim, Milo wrote:
> Hi Guenter
> 
> > I really don't like that idea. It defeats a significant part of the
> > purpose
> > for having a watchdog, which is to prevent user-space hangups.
> > 
> > To make this a driver option is even more odd - it forces every user of
> > this
> > driver to use it in-kernel only, and makes /dev/watchdog quite useless.
> > 
> > I mean, really, if you have such a watchdog, what is the point of using
> > the
> > watchdog infrastructure in the first place ? Just make it a kernel
> > thread or
> > timer-activated platform code which pings your watchdog once in a while.
> > No
> > need to get the watchdog infrastructure involved in the first place.
> > 
> > Am I missing something ?
> 
> I wanted to enable the watchdog timer without the watchdog application for
> making sure the system alive.
> However, I think I misunderstood the purpose of the watchdog driver.
> The watchdog is for detecting user-space hangups rather than kernel stall.
> Is it correct? If yes, this patch is totally wrong.
> 
Correct. After all, if the kernel stalls, user space will stall as well, so by
covering user space it covers both. Covering kernel alone doesn't help much,
since most of the stalls (at least in my experience) happen in user space.

Guenter
