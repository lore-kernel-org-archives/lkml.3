Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691Ab3DDN1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760184Ab3DDN1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:27:44 -0400
Date: Thu, 4 Apr 2013 15:27:34 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: "Theodore Ts'o" <tytso@mit.edu>
cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
In-Reply-To: <20130404132048.GB4756@thunk.org>
Message-ID: <alpine.LFD.2.00.1304041526290.10110@localhost>
References: <20130404104319.42d97a8ad7badf00af7ef1e0@canb.auug.org.au> <alpine.LFD.2.00.1304041516160.30499@localhost> <20130404132048.GB4756@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1351506952-1365082057=:10110"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1351506952-1365082057=:10110
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 4 Apr 2013, Theodore Ts'o wrote:

> Date: Thu, 4 Apr 2013 09:20:48 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
>     linux-kernel@vger.kernel.org
> Subject: Re: linux-next: build failure after merge of the ext4 tree
> 
> On Thu, Apr 04, 2013 at 03:18:32PM +0200, Lukáš Czerner wrote:
> > I am afraid I do not understand why this is happening. The commit
> > simply replaces ext4_get_group_no_and_offset() with
> > ext4_get_group_number() which has the similar definition in the same
> > header file. Maybe someone knows what this is all about ?
> 
> I've fixed this up already in the ext4 tree.  The problem is that you
> defined the function ext4_get_group_number() as "inline", but the
> function body was only in fs/ext4/balloc.c.  I have no idea why gcc
> wasn't complaining about this on x86, but the fix was to simply
> declare the function as "extern", not as "inline".
> 
> 						- Ted
> 

Ok, that's why I have not seen it in ext4 tree :). I do not know why
I did it, but it was obviously wrong.

Thanks for fixing it.
-Lukas
--8323328-1351506952-1365082057=:10110--
