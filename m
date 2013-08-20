Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3HTDaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:30:24 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:63522 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3HTDaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130820023849.GF6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net> <d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
 <20130820023849.GF6023@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 20:30:02 -0700
Message-ID: <CALCETrU_e309onJKGg4EK2EyiZWCjNROsw83+VAK=2i_FVLWYg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] ext4: Defer mmap cmtime update until writeback
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 7:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Aug 16, 2013 at 04:22:12PM -0700, Andy Lutomirski wrote:
>> A fancier implementation could probably avoid an extra journal
>> transaction by adding a mapping_test_clear_cmtime call in
>> ext4_writepages, but this should already be a considerable
>> improvement -- we'll start one transaction per writepages call
>> instead of one per page.
>
> I'd like to see more than just an ext4 implementation - btrfs and
> XFS are the other main filesystems that should behave identically.

Will do.

>
> Also, it's worthwhile to write a generic xfstest to ensure that they
> all update the timestamp appropriately - if its' in xfstests, then
> we can basically guarantee that it won't get randomly regressed in
> future, and other filesystems can be easily verified as well sa
> their implement this.
>

Is there a guide to writing an xfstest?  I've already written it as a
standalone C program, so I assume it's easy.

--Andy
