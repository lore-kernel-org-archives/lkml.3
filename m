Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3AUXDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:03:43 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48618 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3AUXDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:03:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olivier Doucet <webmaster@ajeux.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: Performance issue since 3.2.6
Date: Tue, 22 Jan 2013 00:09:41 +0100
Message-ID: <2048745.M7CAe2g1gj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <18379918.sbmR7uiKVn@vostro.rjw.lan> <CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 11:57:06 PM Olivier Doucet wrote:
> Good evening,
> 
> >> I'll try to track this commit.
> >
> > Thanks a lot!
> 
> I failed to find a working version today with CONFIG_PM=y
> (tested 3.2.6, 3.2.5, 3.2.0, 3.0.1, 2.6.32.8). I'll try older kernels tomorrow.

I don't think that's necessary.  It looks like CONFIG_PM=y has never really
worked for you, but you wasn't aware of that.

> I'm very sceptical now : how can a bug with such a big impact (25%
> performance drop) can survive for so many years, with no one seeing it
> ?
> Good point is that benchmark can be easily done (it took less than an
> hour to test a new version). If you have patches to be tested, feel
> free to ask :)
> 
> In the meanwhile, do you think I can compile a working 3.7 kernel ?
> Maybe by activating / deactivating specific options ?

I'm really not sure.  It looks like CONFIG_PM makes PM QoS affect cpuidle
for you in a wrong way, so to speak.

I suppose it's time to look into the code and see what makes the difference.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
