Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3AUWni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:43:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48573 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3AUWnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:43:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olivier Doucet <webmaster@ajeux.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: Performance issue since 3.2.6
Date: Mon, 21 Jan 2013 23:49:34 +0100
Message-ID: <18379918.sbmR7uiKVn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAPPqfY3vZX3a-GONmzoWdn7sp=_pzKL2qAKBxYZ9ABNLetKoag@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com> <2462618.rQxKXSuBtr@vostro.rjw.lan> <CAPPqfY3vZX3a-GONmzoWdn7sp=_pzKL2qAKBxYZ9ABNLetKoag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 03:26:10 PM Olivier Doucet wrote:
> >> FYI, I benchmarked a new version with :
> >> CONFIG_PM_RUNTIME=y
> >> CONFIG_PM=y
> >>
> >> but the performance loss is still present.
> >
> > In that case it is not quite likely that the commit you bisected to
> > really introduced the problem, because it doesn't change things for
> > CONFIG_PM=y.
> >
> > Does reverting that commit still help?
> 
> I tested several combinations. Results follows :
> 3.2.6 (base) + CONFIG_PM unset  => BAD
> 3.2.6 (base) + CONFIG_PM=y  => BAD
> 3.2.6 (base) + patch reverted + CONFIG_PM=y  => BAD
> 3.2.6 (base) + patch reverted + CONFIG_PM unset  => GOOD

I see.  Two bugs, then.

> So if I understand right, the targeted patch introduced the bug when
> CONFIG_PM is unset, but there is an other bug when this var is set.
> I'll try to track this commit.

Thanks a lot!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
