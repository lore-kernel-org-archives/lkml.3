Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaESRFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:05:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbaESRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:05:49 -0400
Message-ID: <537A39ED.3030902@kernel.dk>
Date: Mon, 19 May 2014 11:05:49 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
References: <20140519141309.GB21570@infradead.org> <537A11CC.5060708@kernel.dk> <20140519142519.GI18016@ZenIV.linux.org.uk> <537A15B9.6000102@kernel.dk> <20140519143416.GC568@infradead.org> <20140519163942.GJ18016@ZenIV.linux.org.uk>
In-Reply-To: <20140519163942.GJ18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 10:39 AM, Al Viro wrote:
> On Mon, May 19, 2014 at 07:34:16AM -0700, Christoph Hellwig wrote:
>> On Mon, May 19, 2014 at 08:31:21AM -0600, Jens Axboe wrote:
>>>> While you are at it, could you take bio-integrity.c with it?  _That_
>>>> has zero excuse being anywhere in fs/* - not even "filesystem code
>>>> uses quite a few functions from that sucker" as with bio.c.
>>>> FWIW, consider the move ACKed.
>>>
>>> Yeah, I did include that in the move.
>>
>> Other candidates to move to block/ might be ioprio.c and no-block.c
> 
> ACK on ioprio.c (BTW, looking at block...  WTF is the story with that
> pile of blk-* in there?  IOW, why blk-exec.c is better than exec.c,
> etc.?)

Intent was to separate the core code from the other code, back when it
was all split from ll_rw_blk.c. I'd still prefer it that way, as opposed
to (eg) putting it in block/core/exec.c.

-- 
Jens Axboe

