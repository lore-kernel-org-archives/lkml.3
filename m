Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaCTQND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:13:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbaCTQMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:12:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Girish K S <ks.giri@samsung.com>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Ilho Lee <ilho215.lee@samsung.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Date: Thu, 20 Mar 2014 17:12:46 +0100
Message-ID: <7073716.9YBOcHOu36@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CABb+yY1rvozkGS34CHt8YEJqvGRXuHV09=AdS3=zQBx=DjFDCQ@mail.gmail.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com> <201403191846.28563.arnd@arndb.de> <CABb+yY1rvozkGS34CHt8YEJqvGRXuHV09=AdS3=zQBx=DjFDCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:G3COBO/Oi3M/vT99/L74cC7hgLGLD2eIbd0bhK1VTc8
 HTI3CJXEvtSt53pqMGieceNi75HiGTkUY1fM5BOLr7E1TzkD71
 yYEF/mX8XYVCYEctf7hCYRbgtpBj1DjCTCX0j9fSYRb097SkWC
 bMARjk1wQU5T7M7o//fzChPZqB4do5BCvKuW+YM1Tck43JINP3
 Nn3fjz3cJvHBmG3nDm64B08IXqkj9rfVFdhZgzAyKUA+i/uj24
 9wjCsVgv2a9qJ57Qee8/XkFTu0vwcRzwfracsKidqy46bS4x1/
 1Ia6KLowIUZX0HSBXEcD0J9aB0fTL3Ad14RrpjzZOhBd+Ik7GF
 4n9E0HavZbuRY++pND68=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 21:39:56 Jassi Brar wrote:
> On Wed, Mar 19, 2014 at 11:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 17 March 2014, Jassi Brar wrote:
> 
> >>   Perhaps the mailbox controller driver should name its links as it
> >> wants. By how the remote works with the mailbox links, the client
> >> driver asks for a specific mailbox link (which maybe a hardcoded
> >> string in the driver or be gotten alongside other data via client's
> >> DT) ?
> >
> > I don't see why we should do it any different from the other bindings.
> > Let's just stick with mboxes/mbox-names or mailboxes/mailbox-names
> > if you prefer.
> >
> >>   IOW we can't have a generic API/DT-bindings that could get us
> >> reusable client drivers. But only common framework/code that would
> >> otherwise be duplicated by every platform.
> >
> > That is a major benefit though.
> > Also even if most drivers won't work across multiple platforms, there
> > is still a reasonable chance that /some/ drivers will.
> >
> It seems those /some/ drivers will have to work with everything same
> but the channel name (which the client could get from its DT node when
> the second platform appears).

Why would you ever have varying channel names? I would expect that
the name is always fixed in the binding of the client driver, like
we do for clocks or interrupts for instance.

	Arnd
