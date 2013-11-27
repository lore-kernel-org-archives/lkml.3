Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3K0HtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:49:02 -0500
Received: from mail.precitec.de ([85.115.17.50]:43900 "EHLO mail.precitec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3K0HtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:49:00 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 02:49:00 EST
X-CTCH-RefID: str=0001.0A0C0207.5295A2AC.0081,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
To: Len Brown <lenb@kernel.org>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] intel_idle: Fixed C6 state on Avoton/Rangeley
 processors
Thread-Topic: [PATCH v2] intel_idle: Fixed C6 state on Avoton/Rangeley
 processors
Thread-Index: AQHO6qzIhv1XjUFGzUekxvfzDKdTiJo3yKgAgADaAIA=
Date: Wed, 27 Nov 2013 07:43:39 +0000
Message-ID: <1385538219.4577.5.camel@po-d-abo-ubu>
References: <1385450037.4588.10.camel@po-d-abo-ubu>
	 <1574800.Vl6NB1rGSk@amdc1032> <1385473105.4588.14.camel@po-d-abo-ubu>
	 <CAJvTdKm8bcUsnn_=_f_NQzJJ_FgmX6Ch3XDK3un22vwE9_Qh_Q@mail.gmail.com>
In-Reply-To: <CAJvTdKm8bcUsnn_=_f_NQzJJ_FgmX6Ch3XDK3un22vwE9_Qh_Q@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <63FD2D67C3C59C43AF9BC7204AEA0934@precitecgroup.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR7nFg1019490


On Tue, 2013-11-26 at 13:43 -0500, Len Brown wrote: 
> >                 .desc = "MWAIT 0x51",
> > -               .flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> > +               .flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> >                 .exit_latency = 15,
> >                 .target_residency = 45,
> 
> Thanks for noticing that .desc and .flags are inconsistent.
> This is my fault -- apparently I e-mailed a version of this patch that
> is older than what I have in my git tree.
> 
> No big issue, though, as 0x51 and 0x58 do exactly the same thing in
> AVN hardware.
> Indeed, changing .desc to 0x58 would be fine also.


The Rangeley on my Supermicro A1SRi-2758F board won't enter C6 with
MWAIT flag set to 0x58 but will do that with 0x51. Maybe the missing
turbo mode of the Rangeley ?


Arne
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
