Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3D2QGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:06:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31882 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3D2QGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:06:20 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: linux-next: build failure after merge of the nfsd tree
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20130429154541.GI17268@fieldses.org>
Date: Mon, 29 Apr 2013 12:05:51 -0400
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Content-Transfer-Encoding: 8BIT
Message-Id: <09A69F90-5D9A-4AF6-9B7D-CC1D74A237EA@oracle.com>
References: <20130429112434.dcc80cfce804beeacc68793a@canb.auug.org.au> <CA52A586-E4DF-42D0-9020-D17F8822BF7C@oracle.com> <20130429154541.GI17268@fieldses.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
X-Mailer: Apple Mail (2.1503)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 29, 2013, at 11:45 AM, "J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Mon, Apr 29, 2013 at 10:53:37AM -0400, Chuck Lever wrote:
>> 
>> On Apr 28, 2013, at 9:24 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> 
>>> Hi J.,
>>> 
>>> After merging the nfsd tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>> 
>>> net/sunrpc/auth_gss/svcauth_gss.c: In function 'gss_proxy_save_rsc':
>>> net/sunrpc/auth_gss/svcauth_gss.c:1182:3: error: implicit declaration of function 'gss_mech_get_by_OID' [-Werror=implicit-function-declaration]
>>> 
>>> Caused byc ommit 030d794bf498 ("SUNRPC: Use gssproxy upcall for server
>>> RPCGSS authentication").  gss_mech_get_by_OID() made static to
>>> net/sunrpc/auth_gss/gss_mech_switch.c by commit 9568c5e9a61d ("SUNRPC:
>>> Introduce rpcauth_get_pseudoflavor()") in the nfs tree (part of the nfs
>>> tree that you did not merge).
>>> 
>>> I don't know how to fix this, so I have used the nfsd tree from
>>> next-20130426 for today.
>> 
>> Bruce, it might make sense for me to submit the three server-side RPC GSS patches, and then you can rebase the gssproxy work on top of those.  Let me know how you would like to proceed.
> 
> I'm happy to take those patches whenever you consider them ready.  Would
> that fix the problem?

Someone would need to modify the gssproxy patches to use the new interfaces.

> Also: it looks like 030d794bf498 "SUNRPC: Introduce
> rpcauth_get_pseudoflavor()" is in Trond's linux-next, but not his
> nfs-for-next.  I'm not sure what that means--is it safe to rebase on top
> of *that*?

That doesn't seem right to me.

> I was hoping I could consider the gss-proxy work committed at this point
> and pile any fixes on top, but... whatever works for you guys, I guess.
> 
> --b.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




