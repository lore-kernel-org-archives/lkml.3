Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab3B0RqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:46:07 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:47530 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3B0RqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:46:06 -0500
Date: Wed, 27 Feb 2013 18:45:53 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Message-ID: <20130227174553.GA224@x4>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.02.28 at 01:38 +0800, gnehzuil.liu wrote:
> 在 2013-2-28，上午1:22，Markus Trippelsdorf <markus@trippelsdorf.de> 写道：
> 
> > On 2013.02.28 at 01:10 +0800, gnehzuil.liu wrote:
> >> 在 2013-2-28，上午1:01，Markus Trippelsdorf <markus@trippelsdorf.de> 写道：
> >> 
> >>> On 2013.02.27 at 16:44 +0100, Markus Trippelsdorf wrote:
> >>>> On 2013.02.27 at 10:34 -0500, Theodore Ts'o wrote:
> >>>>> On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf wrote:
> >>>>>> Just booted todays Linux tree and got the following errors:
> >>>>>> 
> >>>>>> ...
> >>>>>> Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
> >>>>>> ...
> >>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2569822761, rec_len=3837, name_len=1
> >>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: ignore#70911401: block 15213579: comm pdnsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2000846358, rec_len=36782, name_len=120
> >>>>> 
> >>>>> Is this reproducible? 
> >>> 
> >>> The issue is caused by:
> >>> 
> >>> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> >>> Author: Zheng Liu <wenqing.lz@taobao.com>
> >>> Date:   Mon Feb 18 00:29:59 2013 -0500
> >>> 
> >>>   ext4: lookup block mapping in extent status tree
> >> 
> >> Thanks for the report.  I am very sorry about that.  Now I am trying to fix it.
> >> 
> > Thank you.
> > 
> > Please note that if I run a kernel build with: 
> > "git reset --hard f7fec032aa782d3fd7e51fbdf08aa3a296c01500" 
> > (the commit before d100eef24) I get a different but similar error:
> > 
> >  EXT4-fs (sda): error count: 4
> >  EXT4-fs (sda): initial error at 1361983458: ext4_find_dest_de:1657: inode 70911401: block 15213579 
> >  EXT4-fs (sda): last error at 1361983663: ext4_find_dest_de:1658: inode 70647809: block 14164000
> 
> Yup, thanks for the note.  Could you please revert to this commit
> a25a4e1a5d5dc0f97dddbca44e695c532d8228c1 (the commit before f7fec032)?
> I suspect that commit f7fec032 is the root cause.  Thanks for your
> help. 

git revert 06b0c886214a223dde7b21cbfc3008fd20a8ce16..74cd15cd02708c7188581f279f33a98b2ae8d322
fixes all issues...

-- 
Markus
