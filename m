Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3AOPGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:06:38 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51318 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab3AOPGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:06:37 -0500
Date: Tue, 15 Jan 2013 15:12:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20130115151239.67a8d73d@pyramind.ukuu.org.uk>
In-Reply-To: <50F5464A.7070704@gmail.com>
References: <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
	<CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
	<CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
	<20121227045301.GB17472@x1.alien8.de>
	<20121228115022.GA28009@S2101-09.ap.freescale.net>
	<20121228124026.GB12918@x1.alien8.de>
	<alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
	<20130112183619.GC10630@liondog.tnic>
	<CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
	<20130112131323.31d2a585.akpm@linux-foundation.org>
	<20130113000242.GD10630@liondog.tnic>
	<50F5464A.7070704@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just tested this patch on a macbook pro with i915 and radeon. First I get a nasty lockdep splat, then it locks up completely:
> 
> [   13.507373] fb: conflicting fb hw usage radeondrmfb vs EFI VGA - removing generic driver

The EFI driver is known to need other work of its own.

Alan
