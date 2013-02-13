Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab3BMQ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:56:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab3BMQ4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:56:12 -0500
MIME-Version: 1.0
Message-ID: <694a9284-7d41-48c6-a55b-634fb2912f43@default>
Date: Wed, 13 Feb 2013 08:55:29 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: sjenning@linux.vnet.ibm.com, minchan@kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@linuxdriverproject.org, ngupta@vflare.org
Subject: RE: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to
 a config option
References: <1360175261-13287-1-git-send-email-dan.magenheimer@oracle.com>
 <20130206190924.GB32275@kroah.com>
 <761b5c6e-df13-49ff-b322-97a737def114@default>
 <20130206214316.GA21148@kroah.com>
 <abbc2f75-2982-470c-a3ca-675933d112c3@default>
 <20130207000338.GB18984@kroah.com>
 <7393d8c5-fb02-4087-93d1-0f999fb3cafd@default>
 <20130211214944.GA22090@kroah.com>
In-Reply-To: <20130211214944.GA22090@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH] staging/zcache: Fix/improve zcache writeback code, tie to a config option
> 
> On Mon, Feb 11, 2013 at 01:43:58PM -0800, Dan Magenheimer wrote:
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> >
> > > So, how about this, please draw up a specific plan for how you are going
> > > to get this code out of drivers/staging/  I want to see the steps
> > > involved, who is going to be doing the work, and who you are going to
> > > have to get to agree with your changes to make it happen.
> > >  :
> > > Yeah, a plan, I know it goes against normal kernel development
> > > procedures, but hey, we're in our early 20's now, it's about time we
> > > started getting responsible.
> >
> > Hi Greg --
> >
> > I'm a big fan of planning, though a wise boss once told me:
> > "Plans fail... planning succeeds".
> >
> > So here's the plan I've been basically trying to pursue since about
> > ten months ago, ignoring the diversion due to "zcache1 vs zcache2"
> > from last summer.  There is no new functionality on this plan
> > other than as necessary from feedback obtained at or prior to
> > LSF/MM in April 2012.
> >
> > Hope this meets your needs, and feedback welcome!
> > Dan
> >
> > =======
> >
> > ** ZCACHE PLAN FOR PROMOTION FROM STAGING **
> >
> > PLAN STEPS

<snip>

> Thanks so much for this, this looks great.
> 
> So, according to your plan, I shouldn't have rejected those patches,
> right?  :)
> 
> If so, please resend them in the next day or so, so that they can get
> into 3.9, and then you can move on to the next steps of what you need to
> do here.

I see it is now in linux-next.  Thanks very much!

For completeness, I thought I should add some planning items
that ARE new functionality.  In my opinion, these can wait
until after promotion, but mm developers may have different
opinions:

ZCACHE FUTURE NEW FUNCTIONALITY

A. Support zsmalloc as an alternative high-density allocator
B. Support zero-filled pages more efficiently
C. Possibly support three zbuds per pageframe when space allows
