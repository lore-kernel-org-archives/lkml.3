Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3I1PUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 11:20:22 -0400
Received: from mx11.netapp.com ([216.240.18.76]:3400 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab3I1PUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 11:20:20 -0400
X-IronPort-AV: E=Sophos;i="4.90,999,1371106800"; 
   d="scan'208";a="54359322"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Zach Brown <zab@redhat.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        Ric Wheeler <rwheeler@redhat.com>,
        Anna Schumaker <schumaker.anna@gmail.com>,
        "Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        "Martin K. Petersen" <mkp@mkp.net>, Jens Axboe <axboe@kernel.dk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Eric Wong <normalperson@yhbt.net>
Subject: RE: [RFC] extending splice for copy offloading
Thread-Topic: [RFC] extending splice for copy offloading
Thread-Index: AQHOrxGOvZ3ZUuiTzUm2hJZkKwekYZnO5LsAgAhvVACAAAa2gIAAARMAgAANuACAABQxAIAAxnuAgACm0ACAACpVgIABe8EAgAAMZoCAAJbAAIAAJwQA
Date: Sat, 28 Sep 2013 15:20:17 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9467EF2D7@SACEXCMBX04-PRD.hq.netapp.com>
References: <CAELBmZBGD4rph=gjLCPKCdEj+nzEQ-F=DExoL+h3vRm7qF7dCQ@mail.gmail.com>
	<20130925183828.GA30372@lenny.home.zabbo.net>
	<CAFX2JfnyF8kyMYzCdqdr2JkoyQCom1bFLpFj89wODjoju54-Ow@mail.gmail.com>
	<20130925190620.GB30372@lenny.home.zabbo.net>
	<20130925195526.GA18971@fieldses.org>
	<20130925210742.GG30372@lenny.home.zabbo.net>
	<CAJfpegsQ0A3T+46o9nsPwaH83JCbgyhgRNGPgzTqs0EcsmDuiQ@mail.gmail.com>
	<20130926185508.GO30372@lenny.home.zabbo.net>	<5244A68F.906@redhat.com>
	<20130927200550.GA22640@fieldses.org>
	<20130927205013.GZ30372@lenny.home.zabbo.net>
 <CAJfpegtdiQzP7t5hc_OaHjSGTrjdZLfKi6fiKqBQ_+AP2Y0-oQ@mail.gmail.com>
In-Reply-To: <CAJfpegtdiQzP7t5hc_OaHjSGTrjdZLfKi6fiKqBQ_+AP2Y0-oQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8SFKda4030294

> -----Original Message-----
> From: Miklos Szeredi [mailto:miklos@szeredi.hu]
> Sent: Saturday, September 28, 2013 12:50 AM
> To: Zach Brown
> Cc: J. Bruce Fields; Ric Wheeler; Anna Schumaker; Kernel Mailing List; Linux-
> Fsdevel; linux-nfs@vger.kernel.org; Myklebust, Trond; Schumaker, Bryan;
> Martin K. Petersen; Jens Axboe; Mark Fasheh; Joel Becker; Eric Wong
> Subject: Re: [RFC] extending splice for copy offloading
> 
> On Fri, Sep 27, 2013 at 10:50 PM, Zach Brown <zab@redhat.com> wrote:
> >> Also, I don't get the first option above at all.  The argument is
> >> that it's safer to have more copies?  How much safety does another
> >> copy on the same disk really give you?  Do systems that do dedup
> >> provide interfaces to turn it off per-file?
> 
> I don't see the safety argument very compelling either.  There are real
> semantic differences, however: ENOSPC on a write to a
> (apparentlÃ­y) already allocated block.  That could be a bit unexpected.  Do we
> need a fallocate extension to deal with shared blocks?

The above has been the case for all enterprise storage arrays ever since the invention of snapshots. The NFSv4.2 spec does allow you to set a per-file attribute that causes the storage server to always preallocate enough buffers to guarantee that you can rewrite the entire file, however the fact that we've lived without it for said 20 years leads me to believe that demand for it is going to be limited. I haven't put it top of the list of features we care to implement...

Cheers,
   Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
