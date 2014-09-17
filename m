Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaIQIXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:23:11 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38736 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaIQIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:23:08 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] treewide: Replace strnicmp with strncasecmp
Organization: D03
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140916215502.GN6205@thunk.org>
X-Hashcash: 1:20:140917:akpm@linux-foundation.org::0CeRO6X+jYd0Zw6V:0000000000000000000000000000000000001fpo
X-Hashcash: 1:20:140917:tytso@mit.edu::OB2oL3pk1x38sOlX:00002QwT
X-Hashcash: 1:20:140917:linux-kernel@vger.kernel.org::WFeEOs2FLaFIOEGq:000000000000000000000000000000000A+Qv
Date: Wed, 17 Sep 2014 10:23:04 +0200
In-Reply-To: <20140916215502.GN6205@thunk.org> (Theodore Ts'o's message of
	"Tue, 16 Sep 2014 17:55:02 -0400")
Message-ID: <878uliirkn.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16 2014, Theodore Ts'o <tytso@mit.edu> wrote:

> On Tue, Sep 16, 2014 at 10:51:14PM +0200, Rasmus Villemoes wrote:
>> The kernel used to contain two functions for length-delimited,
>> case-insensitive string comparison, strnicmp with correct semantics
>> and a slightly buggy strncasecmp. The latter is the POSIX name, so
>> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
>> for the new strncasecmp to avoid breaking existing users.
>
> For the sake of those people who need to review the patches, can you
> say a bit more about the difference in semantics between strnicmp and
> strncasecmp, and why it's safe to do a global search and replace
> without worrying about the semantic differences?
>

The new strncasecmp is exactly the old strnicmp, making
s/strnicmp/strncasecmp/g a semantic noop. But of course it needs to be
applied after the renaming. Andrew said he'd take these follow-up
patches and make sure they're applied in proper order. Even without the
follow-up patches, strnicmp users shouldn't be affected except for a
very small extra indirection overhead.

The two functions behaved identically whenever the length argument was
non-zero. For len==0, the old strncasecmp however effectively became
strcasecmp.

http://thread.gmane.org/gmane.linux.kernel/1775150/focus=1775152

Thanks,
Rasmus
