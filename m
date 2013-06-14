Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FNMzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:55:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3FNMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:55:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Date: Fri, 14 Jun 2013 14:56:15 +0200
Message-ID: <2766142.mFu63TyH69@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CADApbeh9EJDetkvx9Sq=y58mkhU_X1oo-e_hgZqeBV9nriqTiQ@mail.gmail.com>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com> <201306101035.20924.arnd@arndb.de> <CADApbeh9EJDetkvx9Sq=y58mkhU_X1oo-e_hgZqeBV9nriqTiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mGizQJYKlrdMmyGCqwIwFrW9QHMBWp9IUSm4ztUQJUA
 HCXlOM7ugtXZgpyyTFQ25dN7m8IJMBECk1XTZGCNQXXbPKxC0t
 IpfoAOjvjz18qwdsmlVvX5duUlsHpXy69npEmbcUnrff2waiZ1
 Cln0kqaT8p53l9C4oKV47hgkAqbHkZNMnT0+ClIZU8VUh5cnZ0
 S5S8wME4cwHGocS9czeU0fYv7nFH0J6xO1iSb7u6f6Wq69y7XA
 r0Vu1RmykDm0K1ZFcriMzF4VdlJVINdhTc4qiHEtX886Av6LxZ
 xu/lacNB7K+kxBsttMyzeCbngShyGucmAsJ+dMw6r9LU8gYWPW
 qQTvaqOU92txM/nxad+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 17:15:33 Chao Xie wrote:
> On Mon, Jun 10, 2013 at 4:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> > I guess that is a problem we have on other platforms as well, we should
> > find a generic solution for that. It would be nice to reserve a page
> > in "fixmap" and have common code map the SCU page into that.
> >
> 
> So you mean that reserve a page in arch/arm/asm/include/fixmap.h?

Yes.

> This reserve will depend on the cpu type beacuse only A9 will have SCU part.

I think A5 and ARM11MPCore as well.

> I do not know that in fixmap, the #ifdef is acceptable or not.

Yes, it is. We don't really use fixmap on ARM for anything other than
kmap_atomic at the moment. Please have a look at the powerpc and x86
implementations.

> For the common code to map the SCU page, where do you suggest to put it?

arch/arm/kernel/smp_scu.c.

	Arnd
