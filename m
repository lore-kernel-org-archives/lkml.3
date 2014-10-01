Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaJATB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:01:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbaJATB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:01:56 -0400
Date: Wed, 1 Oct 2014 21:01:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: uHID: fix excepted report type
In-Reply-To: <CANq1E4QGPWNBSLzd3_5NJVNkCjBELREN=_twVdcdSe6efOOJ2Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1410012101350.26311@pobox.suse.cz>
References: <1412179187-15107-1-git-send-email-benjamin.tissoires@redhat.com> <CANq1E4QGPWNBSLzd3_5NJVNkCjBELREN=_twVdcdSe6efOOJ2Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, David Herrmann wrote:

> > diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
> > index f6ec5ea..e094c57 100644
> > --- a/drivers/hid/uhid.c
> > +++ b/drivers/hid/uhid.c
> > @@ -154,7 +154,7 @@ static int __uhid_report_queue_and_wait(struct uhid_device *uhid,
> >
> >         spin_lock_irqsave(&uhid->qlock, flags);
> >         *report_id = ++uhid->report_id;
> > -       uhid->report_type = ev->type;
> > +       uhid->report_type = ev->type + 1;
> 
> Nice catch. We always need the *_REPLY type as response:
> 
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
