Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3BCMxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:53:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54730 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3BCMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:53:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM: make VT switching to the suspend console optional v2
Date: Sun, 03 Feb 2013 13:59:49 +0100
Message-ID: <2642200.VLPEM056qV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130203095609.31867279@jbarnes-t420>
References: <1359819248-3714-1-git-send-email-jbarnes@virtuousgeek.org> <2424360.s1UolC1PMO@vostro.rjw.lan> <20130203095609.31867279@jbarnes-t420>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 03, 2013 09:56:09 AM Jesse Barnes wrote:
> On Sat, 02 Feb 2013 21:50:35 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > + * Drivers can indicate support for switchless suspend/resume, which can
> > > > + * save time and flicker, by using this routine and passing 'false' as
> > > > + * the argument.  If any loaded driver needs VT switching, or the
> > > > + * no_console_suspend argument has been passed on the command line, VT
> > > > + * switches will occur.
> > > > + */
> > > 
> > > It seems to me that we'll need a separate counter for the number of registered
> > > drivers and do the switch if that number is equal to the number of drivers that
> > > have passed false to this thing.
> > > 
> > > In which case we can simplify this slightly and introduce
> > > pm_vt_swtich_not_required(void)
> > 
> > Sorry, that won't be sufficient.  Rather something like pm_vt_switch_get()
> > (indicating "I'll do the switch, thanks") and pm_vt_switch_put() (indicating
> > "now you need to do the switch yourself").
> 
> I thought of both of your approaches before posting this one, but each
> have other problems.  And I found a bug in mine last night.
> 
> So I think I need a separate count of drivers that need the switch, and
> ones that don't.  Then if either no driver has registered or if the
> need_switch count is nonzero, we'll do the switch.  Otherwise, if the
> dont_need_switch is nonzero, we can avoid the switch.  I think that'll
> handle all the cases I outlined.

Yes, it should cover them all I think.

> My code as posted will fail if one driver needs a switch but then two
> switch free drivers register.

I see.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
