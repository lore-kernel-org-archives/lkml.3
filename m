Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbaHZJF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:05:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbaHZJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:05:56 -0400
Date: Tue, 26 Aug 2014 11:05:53 +0200
From: Jan Kara <jack@suse.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Linux UDF support
Message-ID: <20140826090553.GB1581@quack.suse.cz>
References: <201408241446.47042@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201408241446.47042@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Sun 24-08-14 14:46:46, Pali Rohár wrote:
> I would like to know what is state of linux UDF driver. It is 
> experimental or is now suitable for storing data?
  The kernel driver is quite stable. I would happily use it for USB sticks
etc. I would be reluctant to use it for say /home because we don't have any
reasonable repair tool for the filesystem (there are format checkers out
there but they mostly tell you there is a problem, however there's not a
decent tool which would fix the filesystem AFAIK).

> According to wikipedia [1] UDF has open specification format and 
> can be used also for HDDs (not only optical discs).
  Correct.

> In OS support table is written that all major and other minor OSs 
> support UDF FS (without needs for additional programs).
> 
> So it looks like UDF is good candidate for multi OS filesystem. 
> Are there any disadvantages for using UDF on e.g USB flash disk? 
> (when I want read/write support on Linux, Windows 7 and Mac OS X)
  Yes, it is a good candidate for exchange between different OSs. I know
people who use it as such.

> Because lot of manuals say that FAT32 (or NTFS) is only one 
> solution for using USB flash disk on more OS.
> 
> On wikipedia there is one note about linux: Write support is only 
> up to UDF version 2.01. Is this restriction still valid?
  That is correct.

> What will happen if I try to mount FS with UDF version 2.60 in 
> R/W mode on linux? It will fallback to R/O mode? Or newly written 
> files will be in previous (2.01) versions?
  The kernel refuses to mount the filesystem read-write if its revision is
> 2.01. But frankly for interchange between OSs you don't want to use
advanced features anyway (lower chance fs will be supported) and there's not
much benefit since they are mostly aimed at optical media.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
