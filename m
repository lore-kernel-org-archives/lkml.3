Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3IIBFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 21:05:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33234 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3IIBFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 21:05:54 -0400
Date: Sun, 08 Sep 2013 20:05:50 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] kernel-doc: Update script to find more "Return:"
 sections
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
In-Reply-To: <1378254868.7347.40.camel@joe-AO722> (from joe@perches.com on
	Tue Sep  3 19:34:28 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378688750.8385.5@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:34:28 PM, Joe Perches wrote:
> Many kernel-doc return description sections headers
> use variants of the "Return:" section prefix.
> 
> (some or maybe even most of these aren't in
>  kernel-doc sections, but many are)
> 
> $ git grep -E -i "^\s*\*\s*return[s]?:"| \
>   cut -f2- -d":" | awk '{print $1 $2}' | \
>   sort | uniq -c
>     121 *return:
>     838 *Return:
>     778 *RETURN:
>     191 *returns:
>    1965 *Returns:
>     603 *RETURNS:
> 
> Rather than change all of the variants to the
> canonical "Return:", adapt the script to accept
> case insensitive "Return:" and "Returns:"
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> I don't know that this actually works.
> It does seem right though.
> 
> Randy?  Rob?  Can you test this please?

I stopped reading this file at the line "#!/usr/bin/perl -w", but I'm  
not sure if this is the right approach. Something that finds these and  
lets us patch them to the cannonical version might be more appropriate.

Or are you going to add similar fuzzy matching for all the other  
keywords?

Rob