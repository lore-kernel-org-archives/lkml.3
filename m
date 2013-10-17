Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254Ab3JQDoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:44:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54880 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650Ab3JQDoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:44:14 -0400
Date: Wed, 16 Oct 2013 20:44:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Vorontsov <anton@enomsg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, vmpressure: add high level
In-Reply-To: <20131017030512.GA21327@teo>
Message-ID: <alpine.DEB.2.02.1310162042050.30329@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com> <20131017030512.GA21327@teo>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Anton Vorontsov wrote:

> > Vmpressure has two important levels: medium and critical.  Medium is 
> > defined at 60% and critical is defined at 95%.
> > 
> > We have a customer who needs a notification at a higher level than medium, 
> > which is slight to moderate reclaim activity, and before critical to start 
> > throttling incoming requests to save memory and avoid oom.
> > 
> > This patch adds the missing link: a high level defined at 80%.
> > 
> > In the future, it would probably be better to allow the user to specify an 
> > integer ratio for the notification rather than relying on arbitrarily 
> > specified levels.
> 
> Does the customer need to differentiate the two levels (medium and high),
> or the customer only interested in this (80%) specific level?
> 

Only high.

> In the latter case, instead of adding a new level I would vote for adding
> a [sysfs] knob for modifying medium level's threshold.
> 

Hmm, doesn't seem like such a good idea.  If one process depends on this 
being 60% and another depends on it being 80%, we're stuck.  I think it's 
legitimate to have things like low, medium, high, and critical as rough 
approximations (and to keep backwards compatibility), but as mentioned in 
the changelog I want to extend the interface to allow integer writes to 
specify their own ratio.
