Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaJXCtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:49:13 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:65442 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaJXCtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:49:12 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 24 Oct 2014 11:50:14 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/4] mm: cma: Don't crash on allocation if CMA area can't
 be activated
Message-ID: <20141024025014.GA15243@js1304-P5Q-DELUXE>
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1414074828-4488-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <xa1tmw8mlobz.fsf@mina86.com>
 <1463193.4qGZjcvNod@avalon>
 <CAL1ERfPiv6KG5Lim6F0w72z=j47D1KCWhukLc5T6jJPOHTP_mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfPiv6KG5Lim6F0w72z=j47D1KCWhukLc5T6jJPOHTP_mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:02:49AM +0800, Weijie Yang wrote:
> On Fri, Oct 24, 2014 at 7:42 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Michal,
> >
> > On Thursday 23 October 2014 18:53:36 Michal Nazarewicz wrote:
> >> On Thu, Oct 23 2014, Laurent Pinchart wrote:
> >> > If activation of the CMA area fails its mutex won't be initialized,
> >> > leading to an oops at allocation time when trying to lock the mutex. Fix
> >> > this by failing allocation if the area hasn't been successfully actived,
> >> > and detect that condition by moving the CMA bitmap allocation after page
> >> > block reservation completion.
> >> >
> >> > Signed-off-by: Laurent Pinchart
> >> > <laurent.pinchart+renesas@ideasonboard.com>
> >>
> >> Cc: <stable@vger.kernel.org>  # v3.17
> >> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> This patch is good, but how about add a active field in cma struct?
> use cma->active to check whether cma is actived successfully.
> I think it will make code more clear and readable.
> Just my little opinion.
> 

Or just setting cma->count to 0 would work fine.

Thanks.
