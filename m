Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3CSOVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab3CSOVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:21:09 -0400
Date: Tue, 19 Mar 2013 10:21:05 -0400
From: Dave Jones <davej@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4_block_to_path block > max warning.
Message-ID: <20130319142105.GA1465@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130319033555.GA1582@redhat.com>
 <20130319122244.GA32310@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319122244.GA32310@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 08:22:44AM -0400, Theodore Ts'o wrote:
 > On Mon, Mar 18, 2013 at 11:35:55PM -0400, Dave Jones wrote:
 > > Not sure what I did to trigger this, but it's happened a few times while fuzzing syscalls.
 > > Rebooted and fscked, didn't find anything wrong.
 > > 
 > > [ 5084.436288] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 1874853625 > max in inode 34
 > > [ 5167.723925] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 2507988634 > max in inode 34
 > 
 > Yes, this wouldn't be a problem that would be be reflected in an fsck
 > problem.  What warning indicates is that there was an attempt to write
 > to file offset which is larger than what is supported by using
 > indirect blocks.  (Presumably this was probably a ext3 file system
 > mounted using ext4?)
 
Yeah, think so. That was my /boot partition it wandered into.

	Dave

