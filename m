Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3HUQaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:30:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3HUQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:30:31 -0400
Message-ID: <5214EB1E.5050407@oracle.com>
Date: Wed, 21 Aug 2013 11:30:22 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130821130231.GG13330@kvack.org>
In-Reply-To: <20130821130231.GG13330@kvack.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,
First, let me apologize for neglecting to copy you and linux-aio on the
applicable patches. I've been carrying along this patchset, assuming I
had gotten the proper cc's correct a while back, but I somehow missed
the aio pieces.

On 08/21/2013 08:02 AM, Benjamin LaHaise wrote:
> Hello Dave,
> 
> On Thu, Jul 25, 2013 at 12:50:26PM -0500, Dave Kleikamp wrote:
>> This patch series adds a kernel interface to fs/aio.c so that kernel code can
>> issue concurrent asynchronous IO to file systems.  It adds an aio command and
>> file system methods which specify io memory with pages instead of userspace
>> addresses.
> 
> First off, have you tested that this series actually works when merged with 
> the pending AIO changes from Kent?  There a git tree with those pending 
> changes at git://git.kvack.org/~bcrl/aio-next.git , and they're in 
> linux-next.

I've lightly tested the patchset against the linux-next tree, running a
fio job on loop-mounted filesystems of different fs types.

> One of the major problems your changeset continues to carry is that your 
> new read_iter/write_iter operations permit blocking (implicitely), which 
> really isn't what we want for aio.  If you're going to introduce a new api, 
> it should be made non-blocking, and enforce that non-blocking requirement 
> (ie warn when read_iter/write_iter methods perform blockin operations, 
> similar to the warnings when scheduling in atomic mode).  This means more 
> changes for some filesystem code involved, something that people have been 
> avoiding for years, but which really needs to be done.

I'm not really sure how the read_iter and write_iter operations are more
likely to block than the current aio_read and aio_write operations. Am I
missing something?

Thanks,
Dave
