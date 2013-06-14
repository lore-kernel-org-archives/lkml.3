Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3FNQ30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab3FNQ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:29:25 -0400
Date: Fri, 14 Jun 2013 18:22:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v2] MIPS: Reduce _NSIG from 128 to 127 to avoid BUG_ON
Message-ID: <20130614162244.GA15754@redhat.com>
References: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, James Hogan wrote:
>
> However do_group_exit() checks for the core dump bit (0x80) in the exit
> code which matches in this particular case and the kernel panics:
>
>   BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>
> Lets avoid this by changing the ABI by reducing the number of signals to
> 127 (so that the maximum signal number is 127).

Agreed.

Of course I can't ack the change in arch/mips, but to me this looks
like a best solution.

Oleg.

