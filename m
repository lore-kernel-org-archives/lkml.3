Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaISPpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:45:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52102 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaISPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:45:53 -0400
Date: Fri, 19 Sep 2014 08:45:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Move BTRFS RCU string to common library
Message-ID: <20140919154546.GZ4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1411116672.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1411116672.git.osandov@osandov.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091915-1542-0000-0000-000004F29C5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 02:01:28AM -0700, Omar Sandoval wrote:
> This patch series moves the generic RCU string library used internally by BTRFS
> to be accessible by anyone. It provides printk_in_rcu and
> printk_ratelimited_in_rcu to print these strings. In order to avoid a weird
> inconsistency between the two, the first patch fixes printk_ratelimited so it
> passes on the return value from printk.
> 
> The second patch actually moves the RCU string library. Version 2 passes on the
> return values from printk{,_ratelimited} and fixes some style issues.
> 
> Omar Sandoval (2):

For the series:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

>   Return a value from printk_ratelimited
>   Move BTRFS RCU string to common library
> 
>  fs/btrfs/check-integrity.c |  6 +--
>  fs/btrfs/dev-replace.c     | 19 +++++-----
>  fs/btrfs/disk-io.c         |  6 +--
>  fs/btrfs/extent_io.c       |  4 +-
>  fs/btrfs/ioctl.c           |  4 +-
>  fs/btrfs/raid56.c          |  2 +-
>  fs/btrfs/rcu-string.h      | 56 ----------------------------
>  fs/btrfs/scrub.c           | 15 ++++----
>  fs/btrfs/super.c           |  2 +-
>  fs/btrfs/volumes.c         | 14 +++----
>  include/linux/printk.h     |  4 +-
>  include/linux/rcustring.h  | 91 ++++++++++++++++++++++++++++++++++++++++++++++
>  12 files changed, 131 insertions(+), 92 deletions(-)
>  delete mode 100644 fs/btrfs/rcu-string.h
>  create mode 100644 include/linux/rcustring.h
> 
> -- 
> 2.1.0
> 

