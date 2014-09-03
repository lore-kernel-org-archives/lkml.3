Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaICTYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:24:12 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61150 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaICTYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:24:11 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1409771156.911.23.camel@jlt4.sipsolutions.net>
References: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
	<CAKMK7uEYKwXgDPMkA632UVX7+eN5vS6_EJqHYNnEDDg10O68zg@mail.gmail.com>
	<1409771156.911.23.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Sep 2014 21:24:10 +0200
Message-ID: <CAKMK7uG9wodJr1w9EWA4H5ssogK=8z=j70KmtAiCF6=0_cZS9w@mail.gmail.com>
Subject: Re: [RFC] firmware coredump: add new firmware coredump class
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 9:05 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> And if we want to use this for i915 we need some way for tools to go
>> from the i915 drm class device node to the error state, not just from
>> the error state back to the device.
>
> Interesting. That's probably not all that difficult to do (maybe even
> set up a child/parent relationship?) but I actually wanted to avoid a
> hard dependency since there may be cases where the failing device
> disappears, e.g. in the case of USB. I have to think about this case
> more, I guess.

Yeah a hard parent/child won't because the device might drop off the
bus while committing seppuku. But I think we need to be able to follow
the link both ways.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
