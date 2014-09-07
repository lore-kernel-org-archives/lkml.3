Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaIGKUV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 06:20:21 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47092 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIGKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 06:20:20 -0400
Message-ID: <540C3160.9040408@gmail.com>
Date: Sun, 07 Sep 2014 12:20:16 +0200
From: Piotr Karbowski <piotr.karbowski@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
References: <540B8040.5010206@gmail.com> <CAFLxGvx7-KR7JqeH3d5nZ6prSez-32BVq6-SNot3s+Nw=UBVhg@mail.gmail.com>
In-Reply-To: <CAFLxGvx7-KR7JqeH3d5nZ6prSez-32BVq6-SNot3s+Nw=UBVhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/07/2014 01:02 AM, Richard Weinberger wrote:
> Can you please find the offending commit?
> Using an automated bisect run this should be easily doable.

That would be it:

da1ce0670c14d8380e423a3239e562a1dc15fa9e is the first bad commit
commit da1ce0670c14d8380e423a3239e562a1dc15fa9e
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue Apr 1 17:08:43 2014 +0200

     vfs: add cross-rename

     If flags contain RENAME_EXCHANGE then exchange source and 
destination files.
     There's no restriction on the type of the files; e.g. a directory 
can be
     exchanged with a symlink.

     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
     Reviewed-by: Jan Kara <jack@suse.cz>
     Reviewed-by: J. Bruce Fields <bfields@redhat.com>

:040000 040000 86e9be1a42cb91c1068b76700c74ec7fdba5443c 
e0269a1fffefe60cbd6d56ccab6485ff383d728d M	fs
:040000 040000 e677e31ebb0a5b355cefe199cba9453800624905 
7a083642c2ea0698d85bfc9e65b99e8cfb4a7440 M	include
:040000 040000 266252c531debd56ae52e000ed1579dca19ddb35 
bfcb75158276de3feafd45d726f3297dfc139389 M	security

-- Piotr.
