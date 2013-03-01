Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3CABTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:19:46 -0500
Received: from mx12.netapp.com ([216.240.18.77]:33745 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3CABTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:19:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,758,1355126400"; 
   d="dif'?scan'208";a="26875816"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Thread-Topic: linux-next: build failure after merge of the nfsd tree
Thread-Index: AQHOFhizrU6EULY0PE+mPIIUKDe+/5iQj54A
Date: Fri, 1 Mar 2013 01:19:42 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EB@sacexcmbx05-prd.hq.netapp.com>
References: <20130301120401.bcb4a3c571cb0d2b7af96a4b@canb.auug.org.au>
In-Reply-To: <20130301120401.bcb4a3c571cb0d2b7af96a4b@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: multipart/mixed;
	boundary="_002_4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EBsacexcmbx05prdh_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EBsacexcmbx05prdh_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B81173E0E26CFE4FB7481B1160E563D8@tahoe.netapp.com>
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-01 at 12:04 +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the nfsd tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> net/sunrpc/xprtsock.c:1923:30: error: 'struct rpc_task' has no member nam=
ed 'tk_xprt'
>=20
> Caused by commit dc107402ae06 ("SUNRPC: make AF_LOCAL connect
> synchronous") interacting with commit 77102893ae68 ("SUNRPC: Nuke the
> tk_xprt macro") from Linus' tree.
>=20
> I have no idea how to fix this, so I have used the version of the nfsd
> tree from next-20130228 for today.

Hi Bruce,

The attached patch should suffice to fix this up.

Cheers
  Trond

--=20
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

--_002_4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EBsacexcmbx05prdh_
Content-Type: text/x-patch; name="patches_bruce.dif"
Content-Description: patches_bruce.dif
Content-Disposition: attachment; filename="patches_bruce.dif"; size=471;
	creation-date="Fri, 01 Mar 2013 01:19:42 GMT";
	modification-date="Fri, 01 Mar 2013 01:19:42 GMT"
Content-ID: <A3DD39FAB3A2EC46BA009350BD90244D@tahoe.netapp.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMveHBydHNvY2suYyBiL25ldC9zdW5ycGMveHBydHNvY2su
Yw0KaW5kZXggMmU3ZTA5Yy4uYzFkODQ3NiAxMDA2NDQNCi0tLSBhL25ldC9zdW5ycGMveHBydHNv
Y2suYw0KKysrIGIvbmV0L3N1bnJwYy94cHJ0c29jay5jDQpAQCAtMTkxOCw5ICsxOTE4LDggQEAg
b3V0Og0KIAlyZXR1cm4gc3RhdHVzOw0KIH0NCiANCi1zdGF0aWMgdm9pZCB4c19sb2NhbF9jb25u
ZWN0KHN0cnVjdCBycGNfdGFzayAqdGFzaykNCitzdGF0aWMgdm9pZCB4c19sb2NhbF9jb25uZWN0
KHN0cnVjdCBycGNfeHBydCAqeHBydCwgc3RydWN0IHJwY190YXNrICp0YXNrKQ0KIHsNCi0Jc3Ry
dWN0IHJwY194cHJ0ICp4cHJ0ID0gdGFzay0+dGtfeHBydDsNCiAJc3RydWN0IHNvY2tfeHBydCAq
dHJhbnNwb3J0ID0gY29udGFpbmVyX29mKHhwcnQsIHN0cnVjdCBzb2NrX3hwcnQsIHhwcnQpOw0K
IAlpbnQgcmV0Ow0KIA0K

--_002_4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EBsacexcmbx05prdh_--
