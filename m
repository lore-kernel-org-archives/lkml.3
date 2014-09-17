Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaIQOFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:05:15 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29205 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:05:13 -0400
Message-ID: <54199515.6000402@imgtec.com>
Date: Wed, 17 Sep 2014 15:05:09 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] vfs: workaround gcc <4.6 build error in link_path_walk()
References: <1410869255-8506-1-git-send-email-james.hogan@imgtec.com> <20140916173951.GX7996@ZenIV.linux.org.uk>
In-Reply-To: <20140916173951.GX7996@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/14 18:39, Al Viro wrote:
> On Tue, Sep 16, 2014 at 01:07:35PM +0100, James Hogan wrote:
>> Commit d6bb3e9075bb (vfs: simplify and shrink stack frame of
>> link_path_walk()) introduced build problems with GCC versions older than
>> 4.6 due to the initialisation of a member of an anonymous union in
>> struct qstr without enclosing braces.
>>
>> This hits GCC bug 10676 [1] (which was fixed in GCC 4.6 by [2]), and
>> causes the following build error:
>>   fs/namei.c: In function 'link_path_walk':
>>   fs/namei.c:1778: error: unknown field 'hash_len' specified in initializer
>>
>> This is worked around by adding explicit braces.
> 
> IOW, the same thing QSTR_INIT is doing...

QSTR_INIT only initialises len and name, not the hash.

Cheers
James
