Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3JUXMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:12:22 -0400
Received: from sandeen.net ([63.231.237.45]:51959 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3JUXMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:12:21 -0400
Message-ID: <5265B4D2.3000907@sandeen.net>
Date: Mon, 21 Oct 2013 18:12:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>,
        "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com> <5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard>
In-Reply-To: <20131021224459.GE16161@dastard>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/13 5:44 PM, Dave Chinner wrote:
> On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
>> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
>>> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
>>> dereferencing.
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Actually, NACK.

I felt that one coming ;)

>> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
>> xfs_emerg() doesn't.
>>
>> Dave, was that intentional?
> 
> Of course it was. ;) xfs_emerg() is only called from the debug code
> in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().
> 
> In the case of assfail(), it has it's own BUG() call, so it does
> everything just fine.
> 
> In the case of xlog_verify_iclog() when icptr is NULL, it will
> panic immediately after the message is printed, just like the old
> code. i.e. this patch isn't fixing anything we need fixed. 

A BUG() is probably warranted, then.

-Eric
