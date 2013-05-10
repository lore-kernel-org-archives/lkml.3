Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3EJKKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3EJKKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:10:17 -0400
Date: Fri, 10 May 2013 11:10:05 +0100
From: Joe Thornber <thornber@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dmcache: flush superblock stats when retrieving
 status info
Message-ID: <20130510101005.GE20880@debian>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204437.GA5712@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509204437.GA5712@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:44:38PM -0700, Darrick J. Wong wrote:
> When userspace queries dmcache for stats info, we should ensure that all the
> metadata gets flushed out of memory to disk.  The current code neglects to
> update the disk copy of the hit/miss counters.

Nack, I'm afraid.  The commit is there purely to make sure the free
metadata blocks reported from the status are as high as possible.
[When a transaction is open we have to treat all blocks from the
previous transaction as allocated to allow rollback.]
