Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbbAITaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:30:55 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51827 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbAITax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:30:53 -0500
MIME-Version: 1.0
In-Reply-To: <20150108114950.GB3351@infradead.org>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <20141210140347.GA23252@infradead.org> <20141210141211.GD2220@wil.cx>
 <20150105184143.GA665@infradead.org> <20150106004714.6d63023c.akpm@linux-foundation.org>
 <20150108114950.GB3351@infradead.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Jan 2015 13:30:31 -0600
Message-ID: <CAH2r5mtwQEJ1q=a_4TSQyY=Qt7TZ7Dtj9oVGfCHJ+Enrj8v5qQ@mail.gmail.com>
Subject: Re: pread2/ pwrite2
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Milosz Tanski <milosz@adfin.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 5:49 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 06, 2015 at 12:47:14AM -0800, Andrew Morton wrote:
>> > progress, which is a bit frustrating.
>>
>> I took a look at pread2() as well and I have two main issues:
>>
>> - The patchset includes a pwrite2() syscall which has nothing to do
>>   with nonblocking reads and which was poorly described and had little
>>   justification for inclusion.
>
> It allows to do O_SYNC writes on a per-I/O basis.  This is very useful
> for file servers (smb, cifs) as well as storage target devices.

This would be particularly useful for SMB3 as the protocol now allows
write-through vs. no-write-through flag on every write request (not just
on an open, it can be changed on a particular i/o to write-through).
There is also a cache/no-cache hint that can be sent on reads/writes in
the newest SMB3 dialect well (but it is less clear to me how we would
ever decide to set that on the Linux client).




-- 
Thanks,

Steve
