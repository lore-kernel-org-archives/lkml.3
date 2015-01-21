Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbbAUS3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:29:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbbAUS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:29:11 -0500
Date: Wed, 21 Jan 2015 18:29:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121182905.GQ29656@ZenIV.linux.org.uk>
References: <20150120232726.GA16913@kria>
 <1517211.UYLV49hvpg@sifl>
 <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
 <54BFAA5D.4040108@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFAA5D.4040108@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:32:13AM -0800, Guenter Roeck wrote:
> Another data point (though I have no idea if it is useful or what it means):
> 
> In the working case, path_init sets nd->flags to 0x50 or 0x51.
> In the non-working case (ie for all files with a '/' in the name),
> it sets nd->flags to 0x10 or 0x11, even though it is always called
> with the LOOKUP_RCU bit set in flags.

Umm...  Are those path_init() succeeding or failing?  Note that path_init()
includes "walk everything except for the last component", so your non-working
case is "have it walk anything at all".  What's failing there?  path_init()
or handling the remaining component?
