Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152Ab3JQDFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:05:19 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56282 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761009Ab3JQDFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:05:17 -0400
Date: Wed, 16 Oct 2013 20:05:12 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, vmpressure: add high level
Message-ID: <20131017030512.GA21327@teo>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Wed, Oct 16, 2013 at 05:43:55PM -0700, David Rientjes wrote:
> Vmpressure has two important levels: medium and critical.  Medium is 
> defined at 60% and critical is defined at 95%.
> 
> We have a customer who needs a notification at a higher level than medium, 
> which is slight to moderate reclaim activity, and before critical to start 
> throttling incoming requests to save memory and avoid oom.
> 
> This patch adds the missing link: a high level defined at 80%.
> 
> In the future, it would probably be better to allow the user to specify an 
> integer ratio for the notification rather than relying on arbitrarily 
> specified levels.

Does the customer need to differentiate the two levels (medium and high),
or the customer only interested in this (80%) specific level?

In the latter case, instead of adding a new level I would vote for adding
a [sysfs] knob for modifying medium level's threshold.

Thanks,

Anton
