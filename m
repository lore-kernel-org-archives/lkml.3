Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3LRXwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:52:31 -0500
Received: from leo.clearchain.com ([199.73.29.74]:60466 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3LRXwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:52:30 -0500
Date: Thu, 19 Dec 2013 09:55:04 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-ID: <20131218235504.GA17958@yabbi.redhat.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
 <20131218234009.GA9360@yabbi.redhat.com>
 <1950536.BXYYX85NB4@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1950536.BXYYX85NB4@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.7 (mail.clearchain.com [127.0.0.1]); Thu, 19 Dec 2013 10:22:23 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:48:37PM -0800, Dmitry Torokhov wrote:
> On Thursday, December 19, 2013 09:40:09 AM Peter Hutterer wrote:
> > > +     memset(&abs, 0, sizeof(abs));
> > > +     for (i = valid_cnt; i < cnt; ++i)
> > > +             if (copy_to_user(&pinfo->info[i], &abs, sizeof(abs)))
> > > +                     return -EFAULT;
> > > +
> > > +     return 0;
> > 
> > why don't you return the number of valid copied axes to the user?
> > that seems better even than forcing the remainder to 0.
> 
> Well, if your program messed up buffers that it faulted we do not know
> for sure if data that did not cause fault ended up where it should have
> or if it smashed something else. This condition I think should be
> signaled early.

not 100% sure I understand but I wasn't proposing to remove the -EFAULT, i
was proposing to replace "return 0" with "return valid_cnt".

Cheers,
   Peter
