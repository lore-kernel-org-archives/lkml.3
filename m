Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3D2Qht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:37:49 -0400
Received: from mail-out5.uio.no ([129.240.10.17]:52624 "EHLO mail-out5.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014Ab3D2Qhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:37:48 -0400
X-Greylist: delayed 998 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 12:37:47 EDT
Message-ID: <1367252460.19515.7.camel@leira.trondhjem.org>
Subject: Re: linux-next: build failure after merge of the nfsd tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>
Date: Mon, 29 Apr 2013 12:21:00 -0400
In-Reply-To: <09A69F90-5D9A-4AF6-9B7D-CC1D74A237EA@oracle.com>
References: <20130429112434.dcc80cfce804beeacc68793a@canb.auug.org.au>
	 <CA52A586-E4DF-42D0-9020-D17F8822BF7C@oracle.com>
	 <20130429154541.GI17268@fieldses.org>
	 <09A69F90-5D9A-4AF6-9B7D-CC1D74A237EA@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 173 max rcpts/h 8 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 77DC3D1251296325815ABF6FE492E11BCFD094F6
X-UiO-SPAM-Test: remote_host: 71.238.149.92 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 65 max/h 4 blacklist 0 greylist 0 ratelimit 0
X-UiOonly: 40354225CC6FF3DC808BBF314FDCB89DED4C4787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 12:05 -0400, Chuck Lever wrote:
> On Apr 29, 2013, at 11:45 AM, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > On Mon, Apr 29, 2013 at 10:53:37AM -0400, Chuck Lever wrote:
> >> 
> >> On Apr 28, 2013, at 9:24 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> 
> >>> Hi J.,
> >>> 
> >>> After merging the nfsd tree, today's linux-next build (powerpc
> >>> ppc64_defconfig) failed like this:
> >>> 
> >>> net/sunrpc/auth_gss/svcauth_gss.c: In function 'gss_proxy_save_rsc':
> >>> net/sunrpc/auth_gss/svcauth_gss.c:1182:3: error: implicit declaration of function 'gss_mech_get_by_OID' [-Werror=implicit-function-declaration]
> >>> 
> >>> Caused byc ommit 030d794bf498 ("SUNRPC: Use gssproxy upcall for server
> >>> RPCGSS authentication").  gss_mech_get_by_OID() made static to
> >>> net/sunrpc/auth_gss/gss_mech_switch.c by commit 9568c5e9a61d ("SUNRPC:
> >>> Introduce rpcauth_get_pseudoflavor()") in the nfs tree (part of the nfs
> >>> tree that you did not merge).
> >>> 
> >>> I don't know how to fix this, so I have used the nfsd tree from
> >>> next-20130426 for today.
> >> 
> >> Bruce, it might make sense for me to submit the three server-side RPC GSS patches, and then you can rebase the gssproxy work on top of those.  Let me know how you would like to proceed.
> > 
> > I'm happy to take those patches whenever you consider them ready.  Would
> > that fix the problem?
> 
> Someone would need to modify the gssproxy patches to use the new interfaces.
> 
> > Also: it looks like 030d794bf498 "SUNRPC: Introduce
> > rpcauth_get_pseudoflavor()" is in Trond's linux-next, but not his
> > nfs-for-next.  I'm not sure what that means--is it safe to rebase on top
> > of *that*?
> 
> That doesn't seem right to me.

I've now pulled the rpcsec_gss changes into the nfs-for-next. The main
reason why they were not pulled in earlier was due to uncertainty what
to do about the increase in "AUTH_GSS upcall timed out." syslog
warnings.



