Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab3BSXVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:21:38 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:35709 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab3BSXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:21:36 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Jan Engelhardt <jengelh@inai.de>
Subject: Re: kconfig-frontends-3.8.0.0 release
Date: Wed, 20 Feb 2013 00:21:30 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201302192314.15995.yann.morin.1998@free.fr> <alpine.LNX.2.01.1302192328280.5517@nerf07.vanv.qr>
In-Reply-To: <alpine.LNX.2.01.1302192328280.5517@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302200021.31123.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, All,

On Tuesday 19 February 2013 Jan Engelhardt wrote:
> On Tuesday 2013-02-19 23:14, Yann E. MORIN wrote:
> >I'm pleased to announce the release of kconfig-frontends 3.8.0.0!
> >Go download it there:
> >    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.xz
> >    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.bz2
> 
> This seems to install
> 	/usr/bin/conf   
> 	/usr/bin/diff   
> 	/usr/bin/gettext
> 	/usr/bin/merge
> 	/usr/bin/tweak

By default, the binaries should all ne prefixed with 'kconfig-' to avoid
such name-clashing (as root, in a fresh debootstrap of squeeze here):

---8<---
$ ./configure --prefix=/usr && make && make install
[--SNIP--]
Making install in frontends
Making install in conf
  /bin/bash ../../libtool   --mode=install /usr/bin/install -c conf '/usr/bin/./kconfig-conf'
libtool: install: /usr/bin/install -c .libs/conf /usr/bin/./kconfig-conf
Making install in mconf
  /bin/bash ../../libtool   --mode=install /usr/bin/install -c mconf '/usr/bin/./kconfig-mconf'
libtool: install: /usr/bin/install -c .libs/mconf /usr/bin/./kconfig-mconf
Making install in nconf
  /bin/bash ../../libtool   --mode=install /usr/bin/install -c nconf '/usr/bin/./kconfig-nconf'
libtool: install: /usr/bin/install -c .libs/nconf /usr/bin/./kconfig-nconf
Making install in scripts
Making install in utils
  /bin/bash ../libtool   --mode=install /usr/bin/install -c gettext '/usr/bin/./kconfig-gettext'
libtool: install: /usr/bin/install -c .libs/gettext /usr/bin/./kconfig-gettext
 /usr/bin/install -c tweak '/usr/bin/./kconfig-tweak'
 /usr/bin/install -c diff '/usr/bin/./kconfig-diff'
 /usr/bin/install -c merge '/usr/bin/./kconfig-merge'

$ ls -lrt /usr/bin/*{conf,gettext,diff}
[--SNIP--]
lrwxrwxrwx 1 root root         26 Feb 19 23:11 fakeroot -> /etc/alternatives/fakeroot
lrwxrwxrwx 1 root root         24 Feb 19 23:11 rename -> /etc/alternatives/rename
lrwxrwxrwx 1 root root         21 Feb 19 23:11 c++ -> /etc/alternatives/c++
-rwxr-xr-x 1 root root      37440 Feb 19 23:13 kconfig-conf
-rwxr-xr-x 1 root root     135583 Feb 19 23:13 kconfig-mconf
-rwxr-xr-x 1 root root      95724 Feb 19 23:13 kconfig-nconf
-rwxr-xr-x 1 root root      18748 Feb 19 23:13 kconfig-gettext
-rwxr-xr-x 1 root root       3725 Feb 19 23:13 kconfig-tweak
-rwxr-xr-x 1 root root       3642 Feb 19 23:13 kconfig-diff
-rwxr-xr-x 1 root root       3378 Feb 19 23:13 kconfig-merge
---8<---

(Not all frontends are installed, because that minimal debootstrap is
lacking Qt and GTK+.)

Note, it is possible to override that default tools prefix with any of:
    --program-prefix=PREFIX
    --program-suffix=SUFFIX
    --program-transform-name=PROGRAM
The default is PREFIX='kconfig-' (contrary to the traditional empty prefix).

(I hope that did not trash your system...)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
