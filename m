Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaIPPvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:51:37 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59161 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaIPPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:51:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform devices
Date: Tue, 16 Sep 2014 16:52:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: lee.jones@linaro.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        "'Alexander Shiyan'" <shc_work@mail.ru>, naushad@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, linux-samsung-soc@vger.kernel.org,
        thomas.ab@samsung.com, tomasz.figa@gmail.com, vikas.sajjan@samsung.com,
        chow.kim@samsung.com, "'Michal Simek'" <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        PRASHANTH GODREHAL <prashanth.g@samsung.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com> <20140905101409.68b14cc3@bbrezillon> <000b01cfd1a4$f5ae0d20$e10a2760$@samsung.com>
In-Reply-To: <000b01cfd1a4$f5ae0d20$e10a2760$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409161652.15333.arnd@arndb.de>
X-Provags-ID: V02:K0:OGRX3z9lbk1sJbhBjETaBf8/dzp9QhkXeWaXb1zYrvk
 5U6jxpB6t1WD2z5qlyoeRn91ODVtrjaXWVQ1gqL9bQaVF4se1j
 XzOUS0aaTKQCWhGW2LIFzI+5khacaTkke/T9Vc3HIqy/mjwcad
 iY4002AwJae9r/542Xs49uZl4p5VWcZGyfGZqz3jR3UHEk7bRE
 T3jLCIFc5whsUL4baGeQRxJVwX0ABUgYu0qG4aae1na0gZqy0i
 8qbyqC/a7bfMbvh0k18W3jBm6pOokg/Bv2QQdkWNl9nyZoafGQ
 FPGF8grTm/iaeOp8umPq9ZfvJyFF+gFRySbCtBV54BrEncV9x8
 fb0YYzmtMe1gPwSlxQo8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2014, Pankaj Dubey wrote:
> Hi Arnd,  Lee Jones,
> > On Thu, 04 Sep 2014 10:15:27 +0530
> > Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> 
> Any update on this patch. As already it has been tested on two DT based
> platforms.
> 
> If you think that we can go ahead and break clps711x till it gets migrated
> over DT,
> then please ack this patch, or else if you have opinion to keep support for
> non-DT
> based drivers (clps711x) then I can post another patch keeping platform
> driver support
> for non-DT based platform. 

The rule is that we don't intentionally break things, so please post a
patch that keeps the existing platform driver there. Ideally we get a DT-only
clps711x for the merge window as well, and if that happens we can add another
patch on top to remove that syscon-pdev support again but then we will
have a bisectable kernel that works for every point inbetween.


	Arnd
