Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3GHQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:30:24 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44290 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3GHQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:30:22 -0400
From: Paul Moore <paul@paul-moore.com>
To: Waiman Long <waiman.long@hp.com>, Eric Paris <eparis@parisplace.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, selinux@tycho.nsa.gov
Subject: Re: [PATCH 1/2 v5] SELinux: Reduce overhead of mls_level_isvalid() function call
Date: Mon, 08 Jul 2013 12:30:17 -0400
Message-ID: <2187595.WquvNei6zx@sifl>
User-Agent: KMail/4.10.5 (Linux/3.9.5-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <51D6FE08.8030904@hp.com>
References: <1370886908-65256-1-git-send-email-Waiman.Long@hp.com> <51B70EE4.5030209@tycho.nsa.gov> <51D6FE08.8030904@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 01:10:32 PM Waiman Long wrote:
> On 06/11/2013 07:49 AM, Stephen Smalley wrote:
> > On 06/10/2013 01:55 PM, Waiman Long wrote:

...

> >> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > 
> > Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
> 
> Thank for the Ack. Will that patch go into v3.11?

[NOTE: I add the SELinux list to the CC line, for future reference, be sure to 
send your SELinux patches there.]

Your patch looked reasonable to me and Stephen ACK'd it so I went ahead and 
pulled the 1/2 patch into my lblnet-next tree.  It is probably an abuse of the 
system, but as you noted it in the description, it does have an impact on 
socket creation so it isn't completely unrelated ;)

If you don't want me to include your patch let me know and I'll drop it.

Now, being in my lblnet-next tree means pretty much nothing in terms of 
actually getting upstream, but it will at least get the patch into tomorrow's 
spin of the linux-next tree.  I think is a good thing as it allows you to say 
"my patch has been in linux-next for the past X weeks!" whenever Eric gets 
around to merging patches again.

Here are the details for the lblnet-next tree:

 * git://git.infradead.org/users/pcmoore/lblnet-2.6_next
 * http://git.infradead.org/users/pcmoore/lblnet-2.6_next

Also, a snapshot of what currently resides there:

Paul Moore (9):
      selinux: fix problems in netnode when BUG() is compiled out
      lsm: split the xfrm_state_alloc_security() hook implementation
      selinux: cleanup and consolidate the XFRM alloc/clone/delete/free code
      selinux: cleanup selinux_xfrm_policy_lookup() ... 
      selinux: cleanup selinux_xfrm_sock_rcv_skb() ... 
      selinux: cleanup some comment and whitespace issues in the XFRM code
      selinux: cleanup selinux_xfrm_decode_session()
      selinux: cleanup the XFRM header
      selinux: remove the BUG_ON() from selinux_skb_xfrm_sid()

Waiman Long (1):
      SELinux: Reduce overhead of mls_level_isvalid() function call

 include/linux/security.h        |   26 ++
 security/capability.c           |   15 +
 security/security.c             |   13 -
 security/selinux/hooks.c        |   11 +
 security/selinux/include/xfrm.h |   45 ++--
 security/selinux/netnode.c      |    2
 security/selinux/ss/ebitmap.c   |   20 ++
 security/selinux/ss/ebitmap.h   |    2
 security/selinux/ss/mls.c       |   22 +-
 security/selinux/ss/mls_types.h |    2
 security/selinux/xfrm.c         |  453 ++++++++++++++++---------------------
 11 files changed, 291 insertions(+), 320 deletions(-)

-- 
paul moore
www.paul-moore.com

