Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab3LIQA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:00:26 -0500
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:53508 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566Ab3LIQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:00:25 -0500
Date: Mon, 9 Dec 2013 16:00:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Rik van Riel <riel@redhat.com>
cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and
 change_protection_range
In-Reply-To: <52A29278.9000609@redhat.com>
Message-ID: <00000142d816866f-615798f8-74d8-401c-b35a-88aa1dbc8eb5-000000@email.amazonses.com>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de> <1386060721-3794-15-git-send-email-mgorman@suse.de> <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de>
 <20131206141331.10880d2b@annuminas.surriel.com> <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com> <52A23FD1.3040102@redhat.com> <00000142ca7218fe-a5566a24-0ef5-4545-8a98-d33116b7d703-000000@email.amazonses.com>
 <52A29278.9000609@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Rik van Riel wrote:

> > Ok then what are you trying to fix?
>
> It would help if you had actually read the patch.

I read the patch. Please update the documentation to accurately describe
the race.

>From what I can see this race affects only huge pages and the basic issue
seems to be that huge pages do not use migration entries but directly
replace the pmd (migrate_misplaced_transhuge_page() f.e.).

That is not safe and there may be multiple other races as we add more
general functionality to huge pages. An intermediate stage is needed
that allows the clearing out of remote tlb entries before the new tlb
entry becomes visible.

Then you wont need this code anymore.
