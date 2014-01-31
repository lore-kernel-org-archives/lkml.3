Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbaAaPfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:35:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaAaPfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:35:50 -0500
Date: Fri, 31 Jan 2014 10:35:35 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: clm@fb.com, jeffm@suse.com
Subject: Re: btrfs: add ability to change features via sysfs
Message-ID: <20140131153535.GA30957@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clm@fb.com, jeffm@suse.com
References: <20140131041200.7E860660C9D@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131041200.7E860660C9D@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 04:12:00AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=ba631941ef09c10e229661219dbd1707e56131d8
 > Commit:     ba631941ef09c10e229661219dbd1707e56131d8
 > Parent:     79da4fa4d9dcf8c948ef8b5848f747ef08f6e732
 > Author:     Jeff Mahoney <jeffm@suse.com>
 > AuthorDate: Fri Nov 1 13:07:01 2013 -0400
 > Committer:  Chris Mason <clm@fb.com>
 > CommitDate: Tue Jan 28 13:19:27 2014 -0800
 > 
 >     btrfs: add ability to change features via sysfs
 
 
 > +static int can_modify_feature(struct btrfs_feature_attr *fa)
 > +{
 > +	int val = 0;
 > +	u64 set, clear;
 > +	switch (fa->feature_set) {
 > +	case FEAT_COMPAT:
 > +		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
 > +		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
 > +		break;
 > +	case FEAT_COMPAT_RO:
 > +		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
 > +		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
 > +		break;
 > +	case FEAT_INCOMPAT:
 > +		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
 > +		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
 > +		break;
 > +	default:
 > +		BUG();
 > +	}
 > +
 > +	if (set & fa->feature_bit)
 > +		val |= 1;
 > +	if (clear & fa->feature_bit)
 > +		val |= 2;
 > +
 > +	return val;
 > +}

Coverity flagged 9 new issues in btrfs last night.

It flagged this (and a bunch of similar areas) because the CLEAR defines are 0.

Doing if (0 & fa->feature_bit) is always going to be false.

There's 72 other btrfs bugs at http://scan.coverity.com (twice that of say, ext* or xfs).
Many of them look real, though some look complicated enough that they really need
someone familiar with how btrfs works to know "can't happen". If some of you want
to sign up, I can get the access approved quickly.

thanks,

	Dave

