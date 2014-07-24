Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498AbaGXUMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934176AbaGXUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:12:14 -0400
Date: Thu, 24 Jul 2014 16:11:52 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 07/10] Input - wacom: handle Graphire BT tablets in
 wacom.ko
Message-ID: <20140724201152.GC4190@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406225645-32141-8-git-send-email-benjamin.tissoires@redhat.com>
 <20140724193509.GB26752@core.coreip.homeip.net>
 <20140724194352.GB4190@mail.corp.redhat.com>
 <20140724195827.GC26752@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140724195827.GC26752@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24 2014 or thereabouts, Dmitry Torokhov wrote:
> On Thu, Jul 24, 2014 at 03:43:52PM -0400, Benjamin Tissoires wrote:
> > On Jul 24 2014 or thereabouts, Dmitry Torokhov wrote:
> > > Hi Benjamin,
> > > 
> > > On Thu, Jul 24, 2014 at 02:14:02PM -0400, Benjamin Tissoires wrote:
> > > > +			} else if (features->type == GRAPHIRE_BT) {
> > > > +				/* Compute distance between mouse and tablet */
> > > > +				rw = 44 - (data[6] >> 2);
> > > > +				if (rw < 0)
> > > > +					rw = 0;
> > > > +				else if (rw > 31)
> > > > +					rw = 31;
> > > 
> > > 				rw = clamp_val(rw, 0, 31);
> > > 
> > > ?
> > 
> > could be...
> > 
> > I'll do the tests and resubmit later the v3. I'll wait a little in case
> > you have other comments on the other patches :)
> 
> How about doing it incrementally - the patch is still sound as far as I
> am concerned. I will wait a bit for other to chime in with comments or
> acks before applying this series.
> 

As you want.
Just making the exact changes you mentioned still makes the Graphire
working (what a surprise, isn't it?). So I am fine either way.

Cheers,
Benjamin
