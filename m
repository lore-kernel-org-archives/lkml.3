Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3DWSDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:03:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48384 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756979Ab3DWSDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:03:40 -0400
Message-ID: <1366740217.2036.4.camel@joe-AO722>
Subject: Re: [PATCH V2] usb: storage: Convert US_DEBUGP to usb_stor_dbg
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 23 Apr 2013 11:03:37 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing lkml:

On Mon, 2013-04-22 at 12:35 -0700, David Rientjes wrote:
> On Fri, 19 Apr 2013, Joe Perches wrote:
> 
> > @@ -966,11 +934,13 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
> >  static void realtek_cr_destructor(void *extra)
> >  {
> >       struct rts51x_chip *chip = (struct rts51x_chip *)extra;
> > -
> > -     US_DEBUGP("%s: <---\n", __func__);
> > +     struct us_data *us;
> >  
> >       if (!chip)
> >               return;
> > +
> > +     us = chip->us;
> > +
> >  #ifdef CONFIG_REALTEK_AUTOPM
> >       if (ss_en) {
> >               del_timer(&chip->rts51x_suspend_timer);
> 
> >From linux-next:
> 
> drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
> drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'
> 
> chip->us here is only defined when CONFIG_REALTEK_AUTOPM is enabled.

Thanks.

I'll fix it, but it'll likely be a couple of weeks
until I can.



