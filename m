Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3JRUsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3JRUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:48:07 -0400
Date: Fri, 18 Oct 2013 22:48:04 +0200
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?Q?P=E9ter_Andr=E1s_Felv=E9gi?= <petschy@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] udf: fix for pathetic mount times in case of invalid
 file system
Message-ID: <20131018204804.GA32562@quack.suse.cz>
References: <CAG3eYYSRpBUcSMSbxXTKCFtm1BiRACVvFd77nVb641QYQZWHPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG3eYYSRpBUcSMSbxXTKCFtm1BiRACVvFd77nVb641QYQZWHPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-10-13 20:07:44, Péter András Felvégi wrote:
> From: Peter A. Felvegi <petschy@gmail.com>
> 
> The UDF driver was not strict enough about checking the IDs in the
> VSDs when mounting, which resulted in reading through all the sectors
> of the block device in some unfortunate cases. Eg, trying to mount my
> uninitialized 200G SSD partition (all 0xFF bytes) took ~350 minutes to
> fail, because the code expected some of the valid IDs or a zero byte.
> During this, the mount couldn't be killed, sync from the cmdline
> blocked, and the machine froze into the shutdown. Valid filesystems
> (extX, btrfs, ntfs) were rejected by the mere accident of having a
> zero byte at just the right place in some of their sectors, close
> enough to the beginning not to generate excess I/O. The fix adds a
> hard limit on the VSD sector offset, adds the two missing VSD IDs, and
> stops scanning when encountering an invalid ID. Also replaced the
> magic number 32768 with a more meaningful #define, and supressed the
> bogus message about failing to read the first sector if no UDF fs was
> detected.
  Thanks. I've merged the patch into my tree.

								Honza
> 
> Signed-off-by: Peter A. Felvegi <petschy@gmail.com>
> ---
> The fix was developed for 3.9.4, and applies to 3.12-rc3, too.
> 
> patch v2: edited the code so that added/changed lines are not longer than
> 80 chars. sending the patch as an attachment, as gmail messes it up
> otherwise.


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
