Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3JWABd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:01:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:53819 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3JWABb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:01:31 -0400
Date: Wed, 23 Oct 2013 11:02:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
In-Reply-To: <52601DD8.7090308@schaufler-ca.com>
Message-ID: <alpine.LRH.2.02.1310231047180.7063@tundra.namei.org>
References: <20130920203556.GA8726@www.outflux.net> <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org> <52601DD8.7090308@schaufler-ca.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Casey Schaufler wrote:

> On 10/17/2013 1:02 AM, James Morris wrote:
> > This seems like a regression in terms of separating mechanism and policy.  
> >
> > We have several access control systems available (SELinux, at least) which 
> > can implement this functionality with existing mechanisms using dynamic 
> > policy.
> 
> They said the same thing about Smack.
> 

Nope.  Smack separates mechanism and policy.  The argument then was 
whether we need more than one such enhanced access control system.

The issue now is that we do have several of them (SELinux, Smack, 
AppArmor) which are policy-flexible, whether to regress back to adding 
hard-coded security policies into the kernel.

> The problem there is that you have to buy into the entirety of
> SELinux to implement a small bit of behavior. You have to write
> a policy that takes every aspect of system behavior into account
> when all you care about is loading restrictions on modules.

You always need to consider the behavior of the system as a whole when 
designing security policies.

It's a major step backwards to hard-code a series of ad-hoc policies in 
the kernel.  You still need to compose them somehow, and reason about the 
security of the system as a whole.

> The rationale is that lots of people doing little things is
> likely to get us relevant security in a reasonable amount of time.
> The existing LSMs reflect 20th century technologies and use cases.
> They are fine for multi-user timesharing systems. We need to move
> forward to support networked gaming, phones, tablets and toasters.

You keep making these grand assertions but never provide any detail, or 
any kind of evidence to back them up.  Yet there are many, many examples 
of how the current LSMs meet all of these needs in the 21st century, such 
as Smack being adopted for Tizen, digital television etc.:

http://en.wikipedia.org/wiki/Smack



- James
-- 
James Morris
<jmorris@namei.org>
