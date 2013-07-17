Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3GQOw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab3GQOw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:52:27 -0400
Date: Wed, 17 Jul 2013 10:52:18 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4_da_release_space:1333: ext4_da_release_space: ino 12,
 to_free 1 with only 0 reserved data  blocks
Message-ID: <20130717145218.GA27731@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130716202533.GA16061@redhat.com>
 <20130717125322.GA29294@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717125322.GA29294@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 02:53:22PM +0200, Jan Kara wrote:
 > On Tue 16-07-13 16:25:33, Dave Jones wrote:
 > > I've seen this happen a few times this week..
 >   Thanks for report! Was this when fuzzing or just normal desktop load?
 > What is inode with inode number 12 on your filesystem sdb1? What IO happens
 > to it? Apparently some delalloc accounting went wrong somewhere and it's
 > searching for a needle in a haystack unless we have more details...

It was running this.. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
in a loop. After about 6 hours, that fell out.  It made it all the way through
every test a few times, which is odd, as the test should be fairly deterministic.
Ah, I wasn't capturing the fsx seed. I'll do that on the next run.

Perhaps that will make it easier to reproduce.
 
	Dave

