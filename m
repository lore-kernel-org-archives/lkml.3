Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3JVUtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:49:05 -0400
Received: from sandeen.net ([63.231.237.45]:56819 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab3JVUtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:49:04 -0400
Message-ID: <5266E4BD.8030601@sandeen.net>
Date: Tue, 22 Oct 2013 15:49:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>,
        =?ISO-8859-1?Q?Geyslan_Greg=F3r?= =?ISO-8859-1?Q?io_Bem?= 
	<geyslan@gmail.com>
CC: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com> <5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard> <5265B4D2.3000907@sandeen.net> <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard> <5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard> <CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com> <20131022203946.GB2797@dastard>
In-Reply-To: <20131022203946.GB2797@dastard>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 3:39 PM, Dave Chinner wrote:
> On Tue, Oct 22, 2013 at 08:12:51AM -0200, Geyslan Gregório Bem wrote:
>> 2013/10/21 Dave Chinner <david@fromorbit.com>:
>>> On Mon, Oct 21, 2013 at 07:00:59PM -0500, Eric Sandeen wrote:
>>>> On 10/21/13 6:56 PM, Dave Chinner wrote:
>>>>> On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
>>>
>>> Yes, but to continue the Devil's Advocate argument, the purpose of
>>> debug code isn't to enlightent the casual reader or drive-by
>>> patchers - it's to make life easier for people who actually spend
>>> time debugging the code. And the people who need the debug code
>>> are expected to understand why an ASSERT is not necessary. :)
>>>
>> Dave, Eric and Ben,
>>
>> This was catched by coverity (CID 102348).
> 
> You should have put that in the patch description.
> 
> Now I understand why there's been a sudden surge of irrelevant one
> line changes from random people that have never touched XFS before.
> 
> <sigh>
> 
> Ok, lets churn the code just to shut the stupid checker up. This
> doesn't fix a bug, it doesn't change behaviour, it just makes
> coverity happy. Convert it to the for loop plus ASSERT I mentioned
> in a previous message.

You know, I respectfully disagree, but we might just have to agree
to disagree.  The code, as it stands, tests for a null ptr
and then dereferences it.  That's always going to raise some
eyebrows, coverity or not, debug code or not, drive by or not.


So even for future developers, making the code more self-
documenting about this behavior would be a plus, whether it's by
comment, by explicit ASSERT(), or whatever.  (I don't think
that xfs_emerg() has quite enough context to make it obvious.)

(We don't have to change code to shut up coverity; we can flag
it in the database and nobody else will see it.)

-Eric

> Cheers,
> 
> Dave.
> 

