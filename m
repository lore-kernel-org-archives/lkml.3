Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3AXPeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:34:25 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:54312 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3AXPeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:34:23 -0500
X-ASG-Debug-ID: 1359041662-03d6a508b8552900001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Thu, 24 Jan 2013 10:34:20 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Cong Ding <dinggnu@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix potential null pointer dereference bug
Message-ID: <20130124153420.GC2349@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH] btrfs: fix potential null pointer dereference bug
References: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1359041662
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120779
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 08:27:45AM -0700, Cong Ding wrote:
> The bug happens when rb_node == NULL. It causes variable node to be NULL and
> then the NULL pointer is dereferenced this line:
> 	BUG_ON((struct btrfs_root *)node->data != root);
> 
> Based on my analysis, function tree_search should not return NULL to variable
> rb_node in this case (otherwise here has to be something unknown thing wrong),
> so I replace "if (rb_node)" with UG_ON(!rb_node).
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

I don't want to add more BUG_ON()'s, just return an error.

Josef
