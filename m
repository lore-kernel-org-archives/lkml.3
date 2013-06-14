Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab3FNEDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 00:03:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55653 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3FNEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 00:03:14 -0400
Message-ID: <51BA95ED.8020205@canonical.com>
Date: Thu, 13 Jun 2013 23:02:53 -0500
From: Dave Chiluk <chiluk@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com> <51A918B8.20303@canonical.com> <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com> <51AF9D77.2000901@canonical.com> <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com> <51B205A1.4040405@canonical.com> <20130607161452.GI13110@ZenIV.linux.org.uk> <20130613020122.GA20274@ZenIV.linux.org.uk>
In-Reply-To: <20130613020122.GA20274@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 09:01 PM, Al Viro wrote:
> On Fri, Jun 07, 2013 at 05:14:52PM +0100, Al Viro wrote:
>> On Fri, Jun 07, 2013 at 11:09:05AM -0500, Dave Chiluk wrote:
>>> Can't you just use the patch from my original e-mail?  Anyhow I attached
>>> it an already signed-off patch.
>>>
>>> Al Viro Can you integrate it now?
>>
>> Applied...  FWIW, patch directly in mail body is more convenient to deal with.
I checked
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
and don't see the change, is there somewhere else you applied it, or has
it just not been uploaded yet.

> 
> Actually, looking at that stuff...  Why are we bothering with -EBUSY for
> removal of busy directories on ncpfs, anyway?  It's not just rmdir(), it's
> overwriting rename() as well.  IS_DEADDIR checks in fs/namei.c and fs/readdir.c
> mean that the only method of ncpfs directories that might get called after
> successful removal is ->setattr() and it would be trivial to add the check
> in ncp_notify_change() that would make it fail for dead directories without
> bothering the server at all...
Sounds sane.

As for rename: mv dir1 dir2 works.  I was expecting it to fail similar
to rmdir, but I'm guessing if I trace the code new_dentry->d_count just
happens to = 1 preventing the error path from being taken.

> 
> Related question: what happens if you open / unlink / fchmod on ncpfs?
> 
fchmod returned errno 13: Permission denied

Let me know if you need anything else tested.  Also, please take
everything I say with a grain of salt as this is the first and hopefully
last time, I will ever have to change code in ncpfs.  Frankly, as it has
clearly fallen into disrepair, I'd actually love to see it deprecated in
favour of any other more active network file systems.

Dave.
