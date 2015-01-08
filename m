Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbbAHUdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:33:24 -0500
Received: from sandeen.net ([63.231.237.45]:50528 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbbAHUdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:33:23 -0500
Message-ID: <54AEE98D.5010103@sandeen.net>
Date: Thu, 08 Jan 2015 14:33:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/6] f2fs: support goingdown for fs shutdown
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org> <1420740661-72288-2-git-send-email-jaegeuk@kernel.org> <54AEE06C.90806@sandeen.net> <20150108201843.GA74570@jaegeuk-mac02>
In-Reply-To: <20150108201843.GA74570@jaegeuk-mac02>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/15 2:18 PM, Jaegeuk Kim wrote:
> On Thu, Jan 08, 2015 at 01:54:20PM -0600, Eric Sandeen wrote:
>> On 1/8/15 12:10 PM, Jaegeuk Kim wrote:
>>> This patch add an ioctl to shutdown f2fs, which stops all the further block
>>> writes after this point.
>>
>> would it make sense to just re-use the xfs ioctl nr, if the semantics are
>> the same?
> 
> The semantics are not same for now.
> In order to reuse xfs ioctl, it needs to support options for flushing logs.

the xfs iotl has 3 behaviors optional:

#define XFS_FSOP_GOING_FLAGS_DEFAULT            0x0     /* going down */
#define XFS_FSOP_GOING_FLAGS_LOGFLUSH           0x1     /* flush log but not data */
#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH         0x2     /* don't flush log nor data */

if f2fs currently supports a subset, you could just -EOPNOTSUPP on the others.

If the semantics are completely different, maybe it shouldn't share the
name at all.  ;)

Just a thought...

-Eric

> Thanks,
> 
>>
>> That way any test using it will "just work" on f2fs...
>>
>> -Eric

