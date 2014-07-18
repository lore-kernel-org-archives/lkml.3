Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbaGRLGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:06:36 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34971 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaGRLGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:06:34 -0400
Date: Fri, 18 Jul 2014 12:06:44 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] checkpatch: Add missing c90 types
Message-ID: <20140718110644.GC3114@bark>
References: <cover.1405609481.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1405609481.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:52:00AM -0700, Joe Perches wrote:
> c90 section "6.7.2 Type Specifiers" says:
>     "type specifiers may occur in any order"
> 
> That means that:
>     short int is the same as int short
>     unsigned short int is the same as int unsigned short
>     etc...
> 
> checkpatch currently parses only a subset of these allowed types.
> 
> For instance: "unsigned short" is a found by checkpatch as a
> specific type, but none of the "signed int" or "int short" variants
> are found.
> 
> Change all the existing types to allow signed and unsigned variants.
> Reorder the existing types array to match longest type first.
> 
> Add another table for the "kernel style misordered" variants.
> 
> Add this misordered table to the findable types.
> 
> Warn when the misordered style is used.
> 
> This improves the "Missing a blank line after declarations" test as
> it depends on the correct parsing of the $Declare variable which
> looks for "$Type $Ident;" (ie: declarations like "int foo;").
> 
> Joe Perches (3):
>   checkpatch: Add short int to c variable types
>   checkpatch: Add signed generic types
>   checkpatch: Add test for native c90 types in unusual order
> 
>  scripts/checkpatch.pl | 61 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 53 insertions(+), 8 deletions(-)

Looks like a sane plan to me.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
