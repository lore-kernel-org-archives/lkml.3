Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3CARE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:04:29 -0500
Received: from mout.gmx.net ([212.227.15.19]:51745 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3CARE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:04:27 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/5eMsQwVf5II2sUVMhXfVixbiPwDz6EB9BEzMhKl
	5TDCKOy9QWnzKr
From: Sven Joachim <svenjoac@gmx.de>
To: justin <jlec@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org>
	<1362045557-9123-1-git-send-email-jlec@gentoo.org>
	<874ngwhzuy.fsf@turtle.gmx.de> <51305AC4.2030008@gentoo.org>
	<87obf35xei.fsf@turtle.gmx.de> <5130B183.9080901@gentoo.org>
Date: Fri, 01 Mar 2013 18:04:25 +0100
In-Reply-To: <5130B183.9080901@gentoo.org> (justin's message of "Fri, 01 Mar
	2013 14:47:47 +0100")
Message-ID: <87zjyn2grq.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-01 14:47 +0100, justin wrote:

> On 01/03/13 09:36, Sven Joachim wrote:
>> Historically it seems to be an accident, and the ncurses{w,5}-config
>> scripts should have better been shipped in their development packages.
>> But nowadays we want to make the development packages multiarch-aware,
>> and since the scripts differ on architectures, moving them away from
>> ncurses-bin would mean adding two additional binary packages just for
>> these scripts.
>> 
>> See http://bugs.debian.org/480437 for a discussion on that topic.
>> 
>
> I just tested on an ubuntu installation what happens with the patches
> applied; you simply end up with the warning the you need to install the
> dev package. So I don't see any problem here.

Well, in Debian/Ubuntu are _two_ dev packages, one for the wide API
(libncursesw5-dev), and on for the non-wide API (libncurses5-dev).  Only
the latter should be necessary, but with your original patch people
would need to install the former as well.

>> Well, at least until nconf does not make any effort to explicitly detect
>> and use the wide API, trying ncurses5-config first should work.  If you
>> build ncurses yourself with --enable-widec, there is no -lmenu or -lpanel
>> anyway, these libraries are called menuw and panelw then.
>
> You are right, we only should consider ncurses5-config right now.

That seems unlikely to cause regressions on its own.

Cheers,
       Sven
