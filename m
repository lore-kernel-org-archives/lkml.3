Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3LSICg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:02:36 -0500
Received: from dakara.d-tor.org ([88.198.161.242]:57730 "EHLO dakara.d-tor.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3LSICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:02:33 -0500
Message-ID: <52B2A807.5000608@disconnect.de>
Date: Thu, 19 Dec 2013 09:02:15 +0100
From: arno <arno@disconnect.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [XFS BUG] xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
 needs cleaning
References: <52B1B89A.8030401@disconnect.de> <20131218223312.GP31386@dastard>
In-Reply-To: <20131218223312.GP31386@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-d-tor-MailScanner-Information: Please contact the ISP for more information
X-d-tor-MailScanner-ID: 9B71E8102E0.A241E
X-d-tor-MailScanner: Found to be clean
X-d-tor-MailScanner-From: arno@disconnect.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-Dec-13 11:33 PM, Dave Chinner wrote:
> On Wed, Dec 18, 2013 at 04:00:42PM +0100, arno wrote:
>> Hello,
>>
>> (Please keep me in CC, I'm not subscribed)
>>
>> Just got "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure
>> needs cleaning" when trying to grow a logical Volume. Sorry, I lost the
>> xfs_growfs output.
>>
>> After collecting some info, I ran xfs_repair, and that seemed to fix it,
>> so no harm done. After fixing, the FS had the new, increased size, if
>> that matters.
> 
> This isn't the first time you've grown the filesystem, is it?

No, indeed it isn't.

> On older kernels, growfs could leave trailing garbage in the new
> secondary superblocks it created. This was fixed in kernel v3.8 by
> commit:
> 
> 1375cb6 xfs: growfs: don't read garbage for new secondary superblocks
> 
> This garbage is detected by other changes made in v3.8 that verify
> the secondary superblocks as they are read.
> 
> 9802182 xfs: verify superblocks as they are read from disk
> 
> So if you grew the filesystem on a kernel older than v3.8, growing
> it again on a v3.8+ kernel will detect the superblock corruption and
> throw this error.

I'm pretty sure that last time I grew it, it was with a pre v3.8-kernel.

> xfs_repair was recently fixed to detect the garbage in secondary
> superblocks and zero it:
> 
> cbd7508 xfs_repair: zero out unused parts of superblocks
> 
> So what you need to do is run xfs_repair built from the development
> git tree and run it on your filesystem. That will remove the garbage
> from the superblocks and make this problem go away forever.

Will do. Thanks!

-- 
Regards.
Arno.
