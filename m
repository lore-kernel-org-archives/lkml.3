Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbaGAIlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:41:24 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63226 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640AbaGAIlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:41:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140701081759.GA19708@infradead.org>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	<20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
	<20140701081759.GA19708@infradead.org>
Date: Tue, 1 Jul 2014 10:41:19 +0200
Message-ID: <CAFLxGvwa32SkiwACv8k4DtkSAD9CA8BU7QAb4Onp2WkYMPXgBw@mail.gmail.com>
Subject: Re: [RFC 1/1] proc: constify seq_operations
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, dwalter@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 10:17 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 01:39:39PM -0700, Andrew Morton wrote:
>> On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
>>
>> > proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
>> > are only called in proc_id_map_open with seq_open as
>> > const struct seq_operations so we can constify the 3 structures and update
>> > proc_id_map_open prototype.
>>
>> There are an absolutely enormous number of places where we could
>> constify things.  For sheer sanity's sake I'm not inclined to churn the
>> code in this way unless a patch provides some sort of runtime benefit.
>> And this particular patch doesn't appear to change the generated code
>> at all.
>
> Unlike a lot of the cleanup patches which provide no benefit at all
> constifying op vectors moves them from .text to .data which is not
> marked executable and thus reduce the attack vector for kernel exploits.
>
> So I defintively like to see these much more than a lot of the other
> things filling up the lists.

BTW: Daniel Walter and I are currently working with grsec's constify gcc plugin.
This plugin automatically makes structs const which contain only
function pointers.
Our goal is to bring it mainline. We cannot enable it by default as
many gcc toolchains
have plugin support disabled. But at least as tool in tools/ it would
be handy to create
constify patches automatically...

-- 
Thanks,
//richard
