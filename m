Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3LMKvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:51:06 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57829 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3LMKvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:51:04 -0500
MIME-Version: 1.0
In-Reply-To: <52AAD8D4.2060807@gmx.de>
References: <529217CD.1000204@gmx.de>
	<20131203140214.GB31128@quack.suse.cz>
	<529E3450.9000700@gmx.de>
	<20131203230058.GA24037@quack.suse.cz>
	<20131204130639.GA31973@quack.suse.cz>
	<52A36389.7010103@gmx.de>
	<20131211202639.GE1163@quack.suse.cz>
	<52AAD8D4.2060807@gmx.de>
Date: Fri, 13 Dec 2013 11:51:02 +0100
Message-ID: <CAFLxGvy16wv0m4D+ydmqbksUu9CaEaDtGdtnk1YHa56jAU+SEA@mail.gmail.com>
Subject: Re: [uml-devel] why does index in truncate_inode_pages_range() grows
 so much ?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Jan Kara <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:52 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> On 12/11/2013 09:26 PM, Jan Kara wrote:
>> Thanks! So this works more or less as expected - trinity issued a
>> read at absurdly high offset so we created pagecache page a that
>> offset and tried to read data into it. That failed. We left the
>> page in the pagecache where it was for reclaim to reclaim it when
>> free pages are needed. Everything works as designed except we could
>> possibly argue that it's not the most efficient way to use
>> pages...
>>
>> Patch 'vfs: fix a bug when we do some dio reads with append dio
>> writes' (http://www.spinics.net/lists/linux-fsdevel/msg70899.html)
>> should actually change the situation and we won't unnecessarily
>> cache these pages.
>>
> confirmed - applied to latest git tree of Linus I helps.

Good to know! :-)

-- 
Thanks,
//richard
