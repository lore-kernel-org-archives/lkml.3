Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3APWvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:51:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab3APWvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:51:46 -0500
Date: Wed, 16 Jan 2013 17:51:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130116225141.GC4222@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <1358375723.4593.206.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358375723.4593.206.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 05:35:23PM -0500, Mimi Zohar wrote:
> On Tue, 2013-01-15 at 16:34 -0500, Vivek Goyal wrote:
> > If a binary is signed, verify its signature. If signature is not valid, do
> > not allow execution. If binary is not signed, execution is allowed
> > unconditionally.
> 
> Basically you're building the policy into the executable.  Anyone can
> rebuild the executable and, without signing it, install/replace an
> existing one.  How is this safe?  The signature verification policy
> needs to be defined independently of the executable.

Upon signature verification this executable will also acquire a new
capability(say CAP_SIGNED). And some of the services can be allowed only
if process has that new capability. (TODO item)

So if somebody removes the signature and launches same executable, sure
it will run but it will fail to get some of the kernel services. For
example, in this case it should not be able to call sys_kexec() system
call.

Right now my goal is to not run anything which is not signed. For that
we will need a fully signed user space. And I am not sure that's going
to happen in near future, atleast for the generic case.

Thanks
Vivek
