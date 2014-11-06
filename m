Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKFKGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:06:11 -0500
Received: from usevmg20.ericsson.net ([198.24.6.45]:47871 "EHLO
	usevmg20.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKFKGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:06:08 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 05:06:08 EST
X-AuditID: c618062d-f79206d0000014d2-f7-545aec1b842f
From: Jon Maloy <jon.maloy@ericsson.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcrl@kvack.org" <bcrl@kvack.org>
Subject: RE: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Thread-Topic: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Thread-Index: AQHP+TowPNcDsxwwpUuqIrhkyjtxSpxS2nSAgAAN2YCAAFu2AIAAFriA
Date: Thu, 6 Nov 2014 09:50:58 +0000
Message-ID: <A2BAEFC30C8FD34388F02C9B3121859D1C30879F@eusaamb103.ericsson.se>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
 <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
In-Reply-To: <20141106032533.GU7996@ZenIV.linux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.117.188.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42KZXLrHT1fmTVSIwaOjHBZd/7awWMw538Ji
	0f1KxuLyrjlsFscWiFmc/3uc1YHNY8vKm0we2w6oemz6NInd4/MmOY9NT94yBbBGcdmkpOZk
	lqUW6dslcGVMaEgp6FWpWLGsh62BcYFMFyMnh4SAicSr9tuMELaYxIV769m6GLk4hASOMEps
	/HSEBcJZxiixpOsxWBWbgIbEy2kdQDYHh4iAp8T7NcogNcwCtxglLkw9xwJSIyxgKdHS/YYV
	xBYRsJKYdfIGG4TtJvF74Qd2EJtFQEViwupGsJm8Ar4St3fNhFrWziQxffFBZpAEp4C5xI/N
	a8EaGAVkJXafvc4EYjMLiEvcejKfCeJsAYkle84zQ9iiEi8f/2OFsJUkJi09xwpRryOxYPcn
	NghbW2LZwtfMEIsFJU7OfMIygVFsFpKxs5C0zELSMgtJywJGllWMHKXFqWW56UYGmxiBUXZM
	gk13B+Oel5aHGAU4GJV4eDcUR4UIsSaWFVfmHmKU5mBREuedVTsvWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAPjjLm/zyed8w3L6ix/5jLjztoNlVpS/lXZPKVZ72Lfmf1xCff5cv+U7Y+7
	8Vas6/g/dDprnZlU9ssyYHbVlabytguWijdNDsuZdvrWZrfwbAsqd9q9RZGn543L4VsnZpft
	Ys2q/Xd5mnUX17JABeunjt+iOu9tydX4/8pBbjbPin8+P68tcn+uxFKckWioxVxUnAgAeu+Y
	wJMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Al Viro
> Sent: November-06-14 4:26 AM
> To: David Miller
> Cc: herbert@gondor.apana.org.au; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; bcrl@kvack.org
> Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
> 
> On Wed, Nov 05, 2014 at 04:57:19PM -0500, David Miller wrote:
> > From: Al Viro <viro@ZenIV.linux.org.uk>
> > Date: Wed, 5 Nov 2014 21:07:45 +0000
> >
> > > Ping me when you put it there, OK?  I'll rebase the rest of old
> > > stuff on top of it (similar helpers, mostly).
> >
> > I just pushed it into net-next, thanks Al.
> 
> OK, I've taken the beginning of the old queue on top of net-next; it's in
> git://git.kernel.org//pub/scm/linux/kernel/git/viro/vfs.git iov_iter-net.
> 
> From the quick look at the remaining ->msg_iov users:
> 
> 	* I'll need to add several iov_iter primitives - counterparts of
> checksum.h stuff (copy_and_csum_{from,to}_iter(), maybe some more).
> Not a big deal, I'll do that tomorrow.  That will give us a clean iov_iter-based
> counterpart of skb_copy_and_csum_datagram_iovec().
> 
> 	* a new helper: zerocopy_sg_from_iter().  I have it, actually, but I'd
> rather not step on Herbert's toes - it's too close to the areas his series will
> touch, so that's probably for when his series goes in.
> It will be needed for complete macvtap conversion...
> 
> 	* why doesn't verify_iovec() use rw_copy_check_uvector()?  The
> only real differences I see is that (a) you do allocation in callers (same as
> rw_copy_check_uvector() would've done), (b) you return EMSGSIZE in case
> of too long vector, while rw_copy_check_uvector() returns EINVAL in that
> case and (c) you don't do access_ok().  The last one is described as
> optimization, but for iov_iter primitives it's a serious PITA - for iovec-backed
> instances they are using __copy_from_user()/__copy_to_user(), etc.
> 	It certainly would be nice to have the same code doing all copying of
> iovecs from userland - readv/writev/aio/sendmsg/recvmsg/etc.  Am I
> missing something subtle semantical difference in there?  EMSGSIZE vs
> EINVAL is trivial (we can lift that check into the callers, if nothing else), but I
> could miss something more interesting...
> 
> 	* various getfrag will need to grow iov_iter-based counterparts, but
> ip_append_output() needs no changes, AFAICS.
> 
> 	* crypto stuff will be easy to convert - iov_iter_get_pages() would
> suffice for a primitive
> 
> 	* there's some really weird stuff in there.  Just what is this static int
> raw_probe_proto_opt(struct flowi4 *fl4, struct msghdr *msg) {
>         struct iovec *iov;
>         u8 __user *type = NULL;
>         u8 __user *code = NULL;
>         int probed = 0;
>         unsigned int i;
> 
>         if (!msg->msg_iov)
>                 return 0;
> 
>         for (i = 0; i < msg->msg_iovlen; i++) {
>                 iov = &msg->msg_iov[i];
>                 if (!iov)
>                         continue;
> trying to do?  "If non-NULL pointer + i somehow happened to be NULL, skip it
> and try to use the same pointer + i + 1"?  Huh?  Had been that way since the
> function first went in back in 2004 ("[IPV4] XFRM: probe icmp type/code
> when sending packets via raw socket.", according to historical tree)...
> 
> 	* rds, bluetooth and vsock are doing something odd; need to RTFS
> some more.
> 
> 	* not sure I understand what TIPC is doing - does it prohibit too short
> first segment of ->msg_iov?  

Yes, that is the purpose. It was needed in early versions of TIPC, which was
using TIPC itself, instead of netlink, as carrier of configuration commands.
This option is long gone, and we can safely remove those checks.  I'll
post a patch.

///jon

net/tipc/socket.c:dest_name_check() looks
> odd _and_ potentially racy - we read the same data twice and hope our
> checks still apply.  I asked TIPC folks about that race back in April, but it looks
> like that fell through the cracks...
> 
> Overall, so far it looks more or less feasible - other than the missing csum
> primitives, current mm/iov_iter.c should suffice.  I have _not_ seriously
> looked into sendpage yet; that might very well require some more.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
