Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3FRIde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:33:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35604 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3FRId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <51BF1461.8060401@cogentembedded.com>
References: <20130617163920.04523ba6de50bcc81563f33e@canb.auug.org.au>
	<51BF1461.8060401@cogentembedded.com>
Date: Tue, 18 Jun 2013 10:33:27 +0200
Message-ID: <CABYn4sx3PYBVMyio8uo-KhwprQnCmt_5k2EMaa9_EW2ud2q2nQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the net-next tree
From: Bastian Hecht <hechtb@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei, hello Stephen,

Sergei is completely right I think. He was sceptic about the commit in
a mail some days ago already. Unfortunately I recently haven't had
access to my development environment to check what's up with this
patch. I'm sorry that it ended up to you both to deal with it. I have
written some simple bindings for the sh-eth and wanted to use it for
our DT reference version for the Armadillo board but discarded it as I
saw Nobuhiro Iwamatsu, the author of the sh-eth driver, cooked up some
more mature version. I don't see them in the next branch of Simon, so
until they appear there we can delete commit 9e0b428f079d ("ARM:
shmobile: r8a7740: Add interim sh-eth device name to clocks list")
that is only needed for sh-eth DT usage.

Thanks,

 Bastian


2013/6/17 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> Hello.
>
>
> On 17-06-2013 10:39, Stephen Rothwell wrote:
>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/mach-shmobile/clock-r8a7740.c between commit e5c9b4cd6651
>> ("sh_eth: get R8A7740 support out of #ifdef") from the net-next tree and
>> commit 9e0b428f079d ("ARM: shmobile: r8a7740: Add interim sh-eth device
>> name to clocks list") from the arm-soc tree.
>
>
>    To me that latter commit looked utterly pointless, as there's no device
> tree support for the 'sh-eth' driver yet (and at this stage it isn't even
> going to happen due to procedural platform data). I'm instead going to use
> OF_DEV_AUXDATA() in the platform code which again would render that commit
> pointless.
>
>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
>
>    Thanks.
>
> WBR, Sergei
>
