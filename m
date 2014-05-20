Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaETRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:25:28 -0400
Received: from mail.phunq.net ([184.71.0.62]:41537 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaETRZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:25:25 -0400
From: Daniel Phillips <daniel@phunq.net>
To: Dave Chinner <david@fromorbit.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <tux3@tux3.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Tue, 20 May 2014 10:25:23 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <25ea99c1-b4d8-4d71-996b-b6e0fb371f9e@phunq.net>
In-Reply-To: <a3b84e5d-454d-41cc-a728-6dd6399c5b18@phunq.net>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard>
 <a3b84e5d-454d-41cc-a728-6dd6399c5b18@phunq.net>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

This is to address your concern about theoretical interaction between 
direct IO and Tux3 page fork.

On Monday, May 19, 2014 10:41:40 PM PDT, I wrote:
>> Except that Direct IO impacts on the design of the page forking code
>> (because of how things like get_user_pages() need to be aware of
>> page forking). So you need to have direct IO working to demonstrate
>> that the page forking design is sound.....

Page fork only affects cache pages, so the only interation with direct IO 
is when the direct IO is to/from a mmap. If a direct write races with a 
programmed write to cache that causes a fork, then get_user_pages may pick 
up the old or new version of a page. It is not defined which will be 
written to disk, which is not a surprise. If a direct read races with a 
programmed write to cache that causes a fork, then it might violate our 
strong ordering, but that is not a surprise. I do not see any theoretical 
oopses or life cycle issues.

So Tux3 may allow racy direct read to violate strong ordering, but strong 
ordering would still be available with proper application sequencing. For 
example, direct read to mmap followed by msync would be strongly ordered.

Regards,

Daniel
