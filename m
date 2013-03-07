Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab3CGUu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:50:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56782 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3CGUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:50:58 -0500
Message-ID: <5138FDAE.8060202@wwwdotorg.org>
Date: Thu, 07 Mar 2013 13:50:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, grant.likely@secretlab.ca
CC: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        rob.herring@calxeda.com, torvalds@linux-foundation.org
Subject: Re: 3.9-rc1 regression in arm dtb build
References: <20130306193332.GA6022@amd.pavel.ucw.cz> <5137C404.9060902@wwwdotorg.org> <20130307144506.GB7344@amd.pavel.ucw.cz>
In-Reply-To: <20130307144506.GB7344@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 07:45 AM, Pavel Machek wrote:
> Hi!
>>> commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
>>> Author: Grant Likely <grant.likely@secretlab.ca>
>>> Date:   Tue Nov 27 16:29:11 2012 -0700
> ...
>>> 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
>>> 3.8 tricky
>>
>> It's pretty easy to locate the DTB by automatically looking in
>> arch/*/boot/dts first, then if the file doesn't exist there, looking in
>> arch/*/boot instead as a legacy fallback.
> 
> Unfortunately, that does not work. See 2) below. Stale files even
> survive "make clean".

Oh right. I guess it works fine when having built 3.7 and then building
3.8, since you'd look in the new location first and only fall back to
the old location if missing. However, if you then switch back to 3.7 to
test something, I guess that doesn't work so well.

I tend to always build the dtbs target, so I wasn't affected by this.
And, often run "git clean -f -d -x" too.

Grant, what's your call on this issue; should I/you look into ways to
clean the files better, or do you want to revert this?
