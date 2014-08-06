Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaHFPVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:21:04 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:53197 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHFPVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:21:02 -0400
MIME-Version: 1.0
In-Reply-To: <28626.1406648278@warthog.procyon.org.uk>
References: <cover.1406043029.git.milosz@adfin.com>
	<53CE8862.7020201@adfin.com>
	<28626.1406648278@warthog.procyon.org.uk>
Date: Wed, 6 Aug 2014 11:21:01 -0400
Message-ID: <CANP1eJG572cAR1t+pzCExk7EQWb=aDz77-PuP50GAP2j2mETiw@mail.gmail.com>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Shantanu Goel <sgoel01@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The honest answer is I don't know if it know if needs to be unlocked
before or after. I saw a same pattern with unlocking order inside of
__fscache_attr_changed in the failure case.

If this can be re-ordered I can take care of that in my next version I
submit to you.

- Milosz

On Tue, Jul 29, 2014 at 11:37 AM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> +     wake_cookie = __fscache_unuse_cookie(cookie);
>>       spin_unlock(&cookie->lock);
>> +     if (wake_cookie)
>> +             __fscache_wake_unused_cookie(cookie);
>
> Why do __fscache_unuse_cookie() with cookie->lock held?
>
> David



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
