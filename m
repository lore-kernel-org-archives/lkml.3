Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaIDQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:38:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:25853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbaIDQim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,467,1406617200"; 
   d="scan'208";a="568401184"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Zoran Markovic <zrn.markovic@gmail.com>
CC: Anton Vorontsov <anton@enomsg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Arve Hjonnevag" <arve@android.com>,
        Todd Poynor <toddpoynor@google.com>,
        "John Stultz" <john.stultz@linaro.org>
Subject: RE: [RFC PATCH] pm: prevent suspend until power supply events are
 processed
Thread-Topic: [RFC PATCH] pm: prevent suspend until power supply events are
 processed
Thread-Index: AQHPx/vXcKfhYKBgdkSIzjteWgxVwpvwDCaAgAEfITA=
Date: Thu, 4 Sep 2014 16:37:06 +0000
Message-ID: <20ADAB092842284E95860F279283C5642ED08D93@BGSMSX104.gar.corp.intel.com>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
	<CAOh2x==TSbtOKBn6KOL9Z_M-nkzQOiO+EqSTmEtQeRLXROC1rw@mail.gmail.com>
	<CAOh2x=kNtcse_2sExDPCpRnCmxvmqq1++mkSW6HKY+Vn-SJ9QA@mail.gmail.com>
	<CA+B8BG5Hf8=ki0JDeRR13Mo7QRFDmsDuEpW8ozepvCp5KsY8ZA@mail.gmail.com>
	<CAKohpon7Uxndqg+0JSaJEhfousitDcCvpVLx1jtNtBFHh0WatQ@mail.gmail.com>
 <CAKohpomn5SUmmjs=p6DSCHv-Ec4sv_1VRjVa1NV0waUk0rpd9Q@mail.gmail.com>
In-Reply-To: <CAKohpomn5SUmmjs=p6DSCHv-Ec4sv_1VRjVa1NV0waUk0rpd9Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s84GcnR9011374

If the intention is to prevent suspend while processing the power supply uevents, 
Isn't it a good option to use EPOLLWAKEUP? In Android, it's already used by
healthd to achieve the same.

-Jenny

> Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are
> processed
> 
> On 4 September 2014 10:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >>> >> +       /* dependent power supplies (e.g. battery) may have changed
> >>> >> +        * state as a result of this event, so poll again and hold
> >>> >> +        * the wakeup_source until all events are processed.
> >>> >> +        */
> 
> But isn't this comment still incorrect? Its not about dependent supplies but the race
> between the work-handler and its enqueuing?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
