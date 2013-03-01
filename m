Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3CAWKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:10:55 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42870 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3CAWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:10:54 -0500
Message-ID: <1362175844.3221.7.camel@thor.lan>
Subject: Re: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, markus@trippelsdorf.de,
        linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 17:10:44 -0500
In-Reply-To: <CAOS58YOg20+i3beJsHJjedJ2sOrRfAakc=Pj84bZF0BatEU9HQ@mail.gmail.com>
References: <20130228090846.GA249@x4>
	 <20130301133159.0711f81a.akpm@linux-foundation.org>
	 <20130301213511.GF2481@mtj.dyndns.org> <1362174860.3221.2.camel@thor.lan>
	 <CAOS58YOg20+i3beJsHJjedJ2sOrRfAakc=Pj84bZF0BatEU9HQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 13:56 -0800, Tejun Heo wrote:
> On Fri, Mar 1, 2013 at 1:54 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> >> The WARN_ON() is just for cases where someone might be doing something
> >> crazy with the previous behavior of ignoring high bit.  Maybe I was
> >> being overly paranoid and we should just drop it from idr_find().
> >
> > Can we revert the __lock_timer patch as well then?
> 
> I don't know.  Andrew was worried about the type of timer id.  For
> inotify, it's okay as the type is always int but it's not a bad idea
> to have some form of sanitizing if the type might deviate.

It's the other way around that would be the problem, if idr returned a
type that wasn't representable by timer_t.

IMO, idr should be the sanitizing; either the value is valid and found
or not. But that's just my opinion :)

Regards,
Peter Hurley

