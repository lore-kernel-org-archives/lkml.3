Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaHMNib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:38:31 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58882 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaHMNi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
References: <1400623670-2657-1-git-send-email-dianders@chromium.org>
	<001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
Date: Wed, 13 Aug 2014 06:38:27 -0700
X-Google-Sender-Auth: rVtEUL3fiHosb2Qdkz-0zAREqys
Message-ID: <CAD=FV=XCSTzX04M1TDCf9p4QqZrNsStTKG5s7uYbJNaAKmtkuw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get
 an error
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sunil joshi <joshi@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 21, 2014 at 2:08 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, May 21, 2014, Doug Anderson wrote:
>> If we happened to get a data error at just the wrong time the dw_mmc
>> driver could get into a state where it would never complete its
>> request.  That would leave the caller just hanging there.
>>
>> We fix this two ways and both of the two fixes on their own appear to
>> fix the problems we've seen:
>>
>> 1. Fix a race in the tasklet where the interrupt setting the data
>>    error happens _just after_ we check for it, then we get a
>>    EVENT_XFER_COMPLETE.  We fix this by repeating a bit of code.
>> 2. Fix it so that if we detect that we've got an error in the "data
>>    busy" state and we're not going to do anything else we end the
>>    request and unblock anyone waiting.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
>
> It will be applied after "mmc: dw_mmc: change to use recommended reset procedure"
>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
>
> Thanks,
> Seungwon Jeon

I saw that Ulf applied "mmc: dw_mmc: change to use recommended reset
procedure".  Could we apply this one now, too?  Do you want me to
repost?

-Doug
