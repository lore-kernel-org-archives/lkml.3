Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaCSRrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:47:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaCSRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:47:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
Date: Wed, 19 Mar 2014 18:46:28 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Girish K S <ks.giri@samsung.com>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Ilho Lee <ilho215.lee@samsung.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com> <5346848.pBsh8NcQja@wuerfel> <CABb+yY0XXMQaEuDV0FeURjOijYEUKyqU9Dr6XTDRcxc1qaBu9g@mail.gmail.com>
In-Reply-To: <CABb+yY0XXMQaEuDV0FeURjOijYEUKyqU9Dr6XTDRcxc1qaBu9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403191846.28563.arnd@arndb.de>
X-Provags-ID: V02:K0:LhG9WKUYBnFANVOiHOfyp9K1/5OFm65tE9bFUP+lOfB
 LowfE0Jo6eZZMHTb7IrnT//mayIIN8R73XVSKnKoNUSClGY/l/
 UoKXfdltna8Sp6mBATCA6M6HQULC/A9qkgiyYjleG3Kc5+vHaS
 t6iT3C6mW2SKZeuked8tZPJRr4Qq1/vClBSl7kr4VXWmKUidtw
 DRpBElusX815mkGvPIRv5RsZXRVY0e282YYRv5HRNSkgVF8dlz
 /6b4AhchZ5weJ51cvj/AhGZdZShgDLBhD2RQycMyhyrJx1JG7h
 8L3YTczGPsAClwfL53qjWkkO5HPCKg9XYU1X07Pp8VhOe+d6vI
 7fDFhrW/E467wY9F5xuvTb9+gQIaLd6EIs3Wtzw7G
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2014, Jassi Brar wrote:
> On Mon, Mar 17, 2014 at 5:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 17 March 2014 17:33:59 Girish K S wrote:
> >> +Samsung Mailbox Driver
> >> +
> >> +Required properties:
> >> +- compatible:          Should be one of the following,
> >> +                           "samsung,gh7-mailbox" for
> >> +                               Samsung GH7 SoC series
> >> +                           "samsung,exynos-mailbox" for
> >> +                               exynosx SoC series
> >> +- reg:                 Contains the mailbox register address range (base address
> >> +                       and length)
> >> +- interrupts:          Contains the interrupt information for the mailbox
> >> +                       device.
> >> +- samsung,mbox-names:  Array of the names of the mailboxes
> >>
> >
> > I think we should not allow new mailbox drivers that don't conform to
> > the framework that is currently under discussion. In particular, this
> > means don't do a "samsung,mbox-names" property. The current consensus
> > seems to be to have a #mbox-cells" property that allows to pass extra
> > parameters from the client driver, and uses an "mboxes" property
> > to reference the mailbox provided.
> >
> > It would be good if you follow up for the subsystem discussion and
> > ensure it gets merged in time, and supports all the use cases you are
> > interested in. The interface is not entirely nailed down yet, so
> > it's a good time to contribute. However, I can already promise that
> > it won't use matching by strings.
> >
> I was just about to submit next revision of framework that this
> Samsung driver conforms to. Now I think I need some expert opinion ...
> (sorry if following is repetition)
> 
>   As Kumar Gala pointed out in the other thread, the mailbox/ipc chain
> is going to be _very_ platform specific so much so that one rethinks
> if a common api is even warranted : because the client driver will be
> different even if just the remote api(which is going to be
> proprietary) changes, keeping everything else same. For example, a
> client driver for Highbank is highly unlikely to be reusable on
> Exynos, even if both used the same mailbox controller. By my limited
> foresight, mailbox assignment via DT doesn't bring us much benefit but
> only ritual code.

I don't see what that would change. Doing a cross-device binding in DT
is hard, as we see by lots of people (e.g. the above "samsung,mbox-names"
crap) getting it wrong. If we do it properly once, everyone can use the
same binding, and common code to parse the connection between the
mailbox driver and the user.

>   Perhaps the mailbox controller driver should name its links as it
> wants. By how the remote works with the mailbox links, the client
> driver asks for a specific mailbox link (which maybe a hardcoded
> string in the driver or be gotten alongside other data via client's
> DT) ?

I don't see why we should do it any different from the other bindings.
Let's just stick with mboxes/mbox-names or mailboxes/mailbox-names
if you prefer.

>   IOW we can't have a generic API/DT-bindings that could get us
> reusable client drivers. But only common framework/code that would
> otherwise be duplicated by every platform.

That is a major benefit though.
Also even if most drivers won't work across multiple platforms, there
is still a reasonable chance that /some/ drivers will.

	Arnd
