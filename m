Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3AaSvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:51:47 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35309 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3AaSvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:51:44 -0500
Date: Thu, 31 Jan 2013 04:25:35 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 1/2] Fix wrong EOF compare
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>
References: <1357871401-7075-1-git-send-email-minchan@kernel.org>
	<xa1tbocvby0s.fsf@mina86.com> <1358077473.32505.10@driftwood>
	<50F2F9CD.6080904@infradead.org>
In-Reply-To: <50F2F9CD.6080904@infradead.org> (from rdunlap@infradead.org on
	Sun Jan 13 12:15:41 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1359627935.12062.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2013 12:15:41 PM, Randy Dunlap wrote:
> On 01/13/13 03:44, Rob Landley wrote:
> > On 01/11/2013 08:21:55 AM, Michal Nazarewicz wrote:
> >> On Fri, Jan 11 2013, Minchan Kim <minchan@kernel.org> wrote:
> >> > The C standards allows the character type char to be singed or  
> unsinged,
> >> > depending on the platform and compiler. Most of systems uses  
> signed char,
> >> > but those based on PowerPC and ARM processors typically use  
> unsigned char.
> >> > This can lead to unexpected results when the variable is used to  
> compare
> >> > with EOF(-1). It happens my ARM system and this patch fixes it.
> >> >
> >> > Cc: Mel Gorman <mgorman@suse.de>
> >> > Cc: Andy Whitcroft <apw@shadowen.org>
> >> > Cc: Alexander Nyberg <alexn@dsv.su.se>
> >> > Cc: Michal Nazarewicz <mina86@mina86.com>
> >>
> >> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> >>
> >> > Cc: Randy Dunlap <rdunlap@infradead.org>
> >> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> >> > ---
> >> >  Documentation/page_owner.c |    7 ++++---
> >> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > My kernel tree doesn't have Documentation/page_owner.c, where do I  
> find this file?
> 
> It's in -mm (mmotm), so Andrew can/should merge this ...

Actually, why is a .c source file at the top level of Documentation?

Example code is nice and all, but this name doesn't say "test" or  
"example" or anything like that, and isn't collated into a subdirectory  
with any kind of explanatory files like all the others are.

Rob