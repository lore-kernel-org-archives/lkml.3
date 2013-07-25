Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3GYTZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:25:11 -0400
Received: from longford.logfs.org ([213.229.74.203]:59907 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3GYTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:25:06 -0400
Date: Thu, 25 Jul 2013 13:53:08 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Taras Glek <tglek@mozilla.com>
Cc: Dhaval Giani <dgiani@mozilla.com>, linux-kernel@vger.kernel.org,
        tytso@mit.edu, vdjeric@mozilla.com, glandium@mozilla.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Message-ID: <20130725175307.GA15590@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <51F1556A.20909@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F1556A.20909@mozilla.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 July 2013 09:42:18 -0700, Taras Glek wrote:
> Footprint wins are useful on android, but it's the
> increased IO throughput on crappy storage devices that makes this
> most attractive.

All the world used to be a PC.  Seems to be Android these days.

The biggest problem with compression support in the past was the
physical properties of hard drives (the spinning type, if you can
still remember those).  A random seek is surprisingly expensive, of a
similar cost to 1MB or more of linear read.  So anything that
introduces more random seeks will kill the preciously little
performance you had to begin with.

As long as files are write-once and read-only from that point on, you
can just append a bunch of compressed chunks on the disk and nothing
bad happens.  But if you have a read-write file with random overwrites
somewhere in the middle, those overwrites will change the size of the
compressed data.  You have to free the old physical blocks on disk and
allocate new ones.  In effect, you have auto-fragmentation.

So if you want any kind of support for your approach, I suspect you
should either limit it to write-once files or prepare for a mob of
gray-haired oldtimers with rainbow suspenders complaining about
performance on their antiquated hardware.  And the mob may be larger
than you think.

Jörn

--
Don't worry about people stealing your ideas. If your ideas are any good,
you'll have to ram them down people's throats.
-- Howard Aiken quoted by Ken Iverson quoted by Jim Horning quoted by
   Raph Levien, 1979
