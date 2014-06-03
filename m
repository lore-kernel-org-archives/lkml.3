Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaFCQb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:31:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55925 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaFCQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:31:55 -0400
Message-ID: <538DF836.5000206@ontolinux.com>
Date: Tue, 03 Jun 2014 18:30:46 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>, Daniel Phillips <daniel@phunq.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <538C360F.7020901@ontolinux.com> <20140603033940.GB14410@dastard> <538D5D78.6040102@ontolinux.com> <20140603145749.GB12890@thunk.org>
In-Reply-To: <20140603145749.GB12890@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:GAYU67xQuV32VFjB3xYvNCK1rsoWDTKsUCYBRYMEd21
 rO9GhLelkDfL6xQ3RhNvC6pOvL71Sw7j0fRbdxnAf6J3udwGT3
 w5/5dsdQUpPtvQkSI/ZdvRwlTlHhDSKPKUbRoU+kD5mmKizlbR
 8FN8ZPw90TAgFhBf1Tn9b5w6Jiw7XVLcZKeclDBIzjGT4oaRHd
 bj7dad/XFelB6IUrbcxdUwkczjPoKlcsP+fq5sUwVl42z/CHn4
 h/opPeJlb5GxTJr/qYkRQQ9ZV8Sj/FERCV2dBEbF/30x0LlfTm
 OZoxoNofbxbpk7CWdiozOiXroBkgsOu/xIAEfdLFKKq4nu+6Og
 sI0K8JIa003us8wh3kZw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the 3rd of June 2014 16:57, Theodore Ts'o wrote:
> On Tue, Jun 03, 2014 at 07:30:32AM +0200, Christian Stroetmann wrote:
>> In general, I do not believe that the complexity problems of soft updates,
>> atomic writes, and related techniques can be solved by hand/manually. So my
>> suggestion is to automatically handle the complexity problem of e.g.
>> dependancies in a way that is comparable to a(n on-the-fly) file-system
>> compiler so to say that works on a very large dependancy graph (having
>> several billions of graph vertices actually). And at this point an
>> abstraction like it is given with Featherstitch helps to feed and control
>> this special FS compiler.
> Well, if you want to try to implement something like this, go for it!

I am already active since some weeks.

> I'd be very curious to see how well (a) how much CPU overhead it takes
> to crunch on a dependency graph with billions of vertices, and (b) how
> easily can it be to express these dependencies and maintainable such a
> dependency language would be.  Sounds like a great research topic, and

To a) A run is expected to take some few hours on a single computing node.

Also, such a graph processing must not be done all the time, but only if 
a new application demands a specific handling of the data in respect to 
e.g. one of the ACID criterias. That is the reason why I put 
"on-the-fly" in paranthesis.

To b) I hoped that file system developers could make some suggestions or 
point to some no-gos.
I am also thinking about Petri-Nets in this relation, though it is just 
an idea.

I would also like to mention that it could be used in conjunction with 
Non-Volatile Memory (NVM) as well.

> I'll note the Call For Papers for FAST 2015 is out, and if you can
> solve these problems, it would make a great FAST 2015 submission:
>
> https://www.usenix.org/conference/fast15/call-for-papers

Are you serious or have I missed the 1st of April once again?
Actually, I could only write a general overview about the approach 
comparable to a white paper, but nothing more.

> Cheers,
>
> 					- Ted
>

Best regards
Christian
