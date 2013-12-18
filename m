Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3LRVLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:11:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LRVK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:10:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Wed, 18 Dec 2013 22:10:30 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312182150.39037.arnd@arndb.de> <1387400193.31516.10.camel@host5.omatika.ru>
In-Reply-To: <1387400193.31516.10.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312182210.30544.arnd@arndb.de>
X-Provags-ID: V02:K0:pE0jcB8DyELn+ok4C4bF43WM6jET0nKTJVkXGq6g0Jr
 MJAQB5CMmetkt7w/CkziWnPIlEVonpuyM1OgnzEdazRU/hDytn
 CfeATM6gwHPCsllHroF+tZHhJnJYInthpVPDYO75kVTl01Xr5c
 08aZ0gm7qosYP6lIvsT+srZdFMZovvFXPaFb1LR4hmWDwcT+fU
 wMmevbWv4RyMEyYbpt79wm4QMPZM0eE3ZOY4h1qg0V/8DQTNwu
 Nyt8yLgo9j8HgHmGsrwB3xeynWRwFigXEVqXYGHACYqdp5UyK8
 hxmZ/+U8/qH/jf5bWT4KZYlJWOGZn6uwVmJHWdeY6tY2XtmL5K
 Q3tUYEjxD+o8FcxPfkG4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 December 2013, Sergei Ianovich wrote:
> > Hmm, this is a bit tricky then. I think it would be best to not
> > use "simple-bus" then, to allow migrating the other platforms later,
> > but that will be a little more work. Maybe you can register a trivial
> > driver in the platform code that only calls of_platform_populate on
> > the device for now?
> 
> Could we postpone this until someone needs this functionality?

We have to be sure that any device tree files you write now can remain
compatible with future kernels if we add it later. My reasoning at first
was that this wouldn't work if we had to change the "compatible" string
for the bus node, but after re-thinking it now I believe that it's fine.

You would still be able to boot a kernel with an old dts file on a new
kernel if it just contains a "simple-bus" node here, as long as it doesn't
need any boot-time setup at the bus controller. We can change the dts
file later if we need to add this functionality, which would break booting
old kernels with the new dts files, which isn't much of a problem in
general.

	Arnd
