Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaLZTao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:30:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34173 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZTan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:30:43 -0500
Date: Fri, 26 Dec 2014 19:30:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Leon Ma <xindong.ma@intel.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, mhocko@suse.cz,
        mingo@kernel.org, peterz@infradead.org, riel@redhat.com,
        ionut.m.alexa@gmail.com, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, di.zhang@intel.com,
        zhonghua.sun@intel.com
Subject: Re: [PATCH] move exit_task_work() before exit_fs().
Message-ID: <20141226193028.GE22149@ZenIV.linux.org.uk>
References: <y>
 <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 03:45:25PM +0800, Leon Ma wrote:
> We encountered following panic. The scenario is the process is exiting and executing its
> task work. When closing dev node, the driver triggers a firmware reload according to device
> status. Because task->fs is set to NULL in exit_fs(), panic happens.
> Task work is a common interface, we should not limite the resource the user will utilize.

Fix your driver.  Forget ->fs being NULL; what will happen if your process
is chrooted?
