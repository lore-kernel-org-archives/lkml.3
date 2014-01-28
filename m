Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaA1MDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:03:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39488 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaA1MDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:03:39 -0500
Date: Tue, 28 Jan 2014 13:03:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stas Sergeev <stsp@list.ru>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Margarita Manterola <margamanterola@gmail.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Stas Sergeev <stsp@users.sourceforge.net>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Caylan Van Larson <i@caylan.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
Message-ID: <20140128120317.GA28381@xo-6d-61-c0.localdomain>
References: <5291E92F.7010609@hurleysoftware.com>
 <1385428582-5577-1-git-send-email-peter@hurleysoftware.com>
 <529D236E.4020002@hurleysoftware.com>
 <529D9DCD.5080003@list.ru>
 <529E0E1F.4010303@hurleysoftware.com>
 <529E2E92.4010004@list.ru>
 <529E6F02.70506@hurleysoftware.com>
 <529F7B35.4050509@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F7B35.4050509@list.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>How is this different from the unpatched kernel?
> >>In the unpatched kernel, if you happen on reader side
> >>to enable icanon while n_tty received all but VEOF (is this
> >>possible at all?),
> >>then the buffer will be flushed, and the remaining VEOF
> >>will get you a nice EOF.
> >>So, in the unpatched kernel you get EOF because the buffer
> >>gets wiped.
> >
> >???
> >
> >Testcase output from 3.12 w/o patch:
> OK, sorry, after a year of rot of my patch in bugzilla, I've
> completely forgot the pre-conditions, which is that the
> buffer is not discarded, just not pushed.
> 
> >Consider the total brute-force approach; a shadow read_flags that
> >distinguishes a real EOF receive from the fake EOF push initiated
> >by the patch.

Was this solved somehow?

Given that it is recent regression, maybe right solution is to do the brute-force patch
now, and worry about effectivity later?

										Pavel
