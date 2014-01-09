Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaAIQMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:12:12 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:59653 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751101AbaAIQMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:12:05 -0500
X-TM-IMSS-Message-ID: <748c53ed0001b9bf@nsa.gov>
Message-ID: <52CEC9DD.4000901@tycho.nsa.gov>
Date: Thu, 09 Jan 2014 11:10:05 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()
References: <20140109101932.0508dec7@gandalf.local.home>	 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>	 <20140109105114.5c409fef@gandalf.local.home>	 <1389283030.15209.56.camel@localhost> <1389283545.15209.59.camel@localhost>
In-Reply-To: <1389283545.15209.59.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 11:05 AM, Eric Paris wrote:
> [adding lsm and selinux]
> 
> Am I just crazy, or was this bug discussed (and obviously not fixed)
> some time ago?
> 
> VFS can still use inodes after security_inode_free_security() was
> called...

I didn't know that was the case; originally when we added the hook it
was not possible.   I have seen a Red Hat bugzilla report about it,
but no upstream discussion.

