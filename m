Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaJUMrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:47:42 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38719 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaJUMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:47:41 -0400
Message-ID: <544655E8.8070004@electrozaur.com>
Date: Tue, 21 Oct 2014 15:47:36 +0300
From: Boaz Harrosh <ooo@electrozaur.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jeff Garzik <jgpobox@gmail.com>, Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jgarzik@pobox.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        osd-dev@open-osd.org
Subject: Re: state of the osdblk driver?
References: <20141021120653.GA9530@infradead.org> <CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com>
In-Reply-To: <CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 03:21 PM, Jeff Garzik wrote:
> On Tue, Oct 21, 2014 at 8:06 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> The osdblk driver hsa seen literally no change except for global
>> API changes since it was merged, and I've never heard of a user.
>>
>> Is this something we want to keep around?  I just noticed it because
>> it's the only non-SCSI user of some of the old block layer tagging
>> functions.
> 
> Drop it, if there are no users.
> 
> It was simulating an OSD, but there did not seem to be much beyond
> academic interest, and some interest in the use of aforementioned
> block functions as a useful exercise in block driver writing.
> 
> 

It is used in testing, its a good way to compare ext4 over objects
vs exofs over objects, kind of compare apples with apples.
(Also at the get go it was a good test that found some bugs in the
 bring up of the osd target)

If there is an old tagging API need removing its fine to just drop
the support, and/or do the minimal change possible. What was the
tag used for anyway?

If it bothers you very much then please remove it, send a patch
and I'll ACK it.

[Just that I thought we don't do that. I can show you a dozen
 ISA scsi LLD controllers which are a complete pain in the neck
 with a all subsection core support. There is not a single system
 on the planet that has this even possible, yet we do not remove
 them nor the ISA bus crap. osdblk at least is a SW only exercise
 that can be very much valid in any system.
]

Your call sir, I'm with you on this
Thanks
Boaz

