Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaKKKR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:17:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:56320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaKKKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486455348"
Message-ID: <1415701073.22887.126.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/4] UBIFS: Add xattr support for symlinks
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 11 Nov 2014 12:17:53 +0200
In-Reply-To: <20141110171253.GA18047@bshelton-desktop>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
	 <1415628106.22887.122.camel@sauron.fi.intel.com>
	 <20141110171253.GA18047@bshelton-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 11:12 -0600, Ben Shelton wrote:
> On 11/10, Artem Bityutskiy wrote:
> > Could you please re-test this with any kernel and carefully verify
> > symlinks. I think this should not work, because in case of symlinks we
> > already store the link target path in the inode, and with this patch the
> > target patch will be over-written with the SELinux label. I expect this
> > to be seen easily on testing - symlink targets should be corrupted.
> > 
> > Artem.
> > 
> 
> I retested this with a 3.18-rc3 kernel on one of our ARM-based targets.
> The kernel has patch 1/4 with your changes, plus patches 2/4, 3/4, and
> 4/4 as posted.

Ben, thanks for re-testing. And yes, I was wrong. Now I checked again
and finally remembered how it works.

So yes, symlink inode has data, and the target is in the data.

If we add an extattr to a symlink, we create a separate inode for that
xattr under the symlink inode. Any new xattr gets a new inode.

Artem.

