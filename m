Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3HFW2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:28:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58470 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3HFW2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:28:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Date: Wed, 07 Aug 2013 00:38:29 +0200
Message-ID: <16202005.zAo69g0VlB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6175A68C@sisaex02sj>
References: <Pine.LNX.4.44L0.1308061719440.930-100000@iolanthe.rowland.org> <B8EFE96D1287C24090BAD9D858E15E6175A68C@sisaex02sj>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 09:38:36 PM Shuah Khan wrote:
> On 08/06/2013 03:22 PM, Alan Stern wrote:
> > On Tue, 6 Aug 2013, Shuah Khan wrote:
> >
> >> With the dev_pm_ops model, drivers have to provide interfaces for each
> >> one of these states.
> >
> > No, they don't.  They can leave out interfaces if they want.
> 
> Yes. Agreed. There is no need to provide each and every interface. Only 
> the ones driver wishes to handle.
> 
> >
> >>   In this case, there will be a conflict since
> >> pm_op() treats this state as freeze where as the driver wants to do
> >> treat it as a suspend/hibernate. In the case of legacy pm_ops, state is
> >> passed in as a parameter and driver could take special action if need
> >> be, based on the state, however in dev_pm_ops model, state is not passed
> >> in. Instead it is handled with state specific pm_ops interfaces.
> >>
> >> For example, if this driver were to be converted to dev_pm_ops, it would
> >> require a freeze interface which will call sl811h_bus_suspend(). Once
> >> that is done, PM_EVENT_PRETHAW will be mapped to freeze() ops and
> >> sl811h_bus_suspend() will be called instead of port_power(sl811, 0);
> >>
> >> What I am getting at is, there is no provision to handle the special
> >> case for PM_EVENT_PRETHAW like in the case of this driver when using
> >> dev_pm_ops.
> >
> > Okay.  So what?
> >
> 
> I am exploring to see if there is a deficiency in dev_pm_ops 
> infrastructure that needs addressing.

No, there isn't.  We determined a few years ago that "freeze" could always be
used instead of "prethaw".  Moreover, there actually is a "thaw" after that
stage if the image restoration fails, so please just use "freeze" here.  Or
just skip it if it is not really needed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
