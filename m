Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3GDGto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:49:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27968 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3GDGtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:49:42 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-df-51d51b042425
Date: Thu, 04 Jul 2013 08:49:32 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Message-id: <20130704084932.2ce698c7@amdc308.digital.local>
In-reply-to: <CAKohpomcaDS93zka0FK5_JMGY96sW0tLhGzMbr_FFM6wQYPh1A@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
 <CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
 <20130627125819.5c90da30@amdc308.digital.local>
 <CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
 <20130627164204.370dc4a6@amdc308.digital.local>
 <CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
 <20130628085457.05d64878@amdc308.digital.local>
 <20130701101516.7945e387@amdc308.digital.local>
 <CAKohponiy3ebnt0_Cdaan5=DkAfA3U4g=m4NnYGLA-a+tPJJQg@mail.gmail.com>
 <20130704074307.282a53dc@amdc308.digital.local>
 <CAKohpomcaDS93zka0FK5_JMGY96sW0tLhGzMbr_FFM6wQYPh1A@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV0W6auBBptWi1j8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52Mdm0XHk
	G7PFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZWy6Mpml4CRrxesL39kbGJexdDFyckgImEi8efoKyhaTuHBvPVsXIxeHkMAiRome
	pesYQRJCAu1MEksmuILYLAKqEtPO7GIGsdkE9CQ+333K1MXIwSEioCXx8mYqSC+zwHYWiUtN
	s9hAaoQFnCS+3vnFDlLDK2At8eGVG0iYUyBYYtemqewQu2axSRw/uRVsJr+ApET7vx/MEAfZ
	SZz7tIEdxOYVEJT4Mfke2KHMQLs2b2tihbDlJTavecs8gVFwFpKyWUjKZiEpW8DIvIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOKKeSe9gXNVgcYhRgINRiYdXwupKoBBrYllxZe4hRgkO
	ZiURXieOq4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUa
	GLuCo+vitxmnel1QuPj68A67na2at1Y/vDJt8vEHdQxuh31jc7scD056d5ClMGH+U/+WdxqC
	Tky9rGISKsVa1g4bzGxrE7bW97u5uvJLtjnYndb9aiYg1Me8WkVfRvPLSZOm698Wa9SdTr3v
	lWfYHNT67a7WaYEzUfcSRbMveh5cY5t6cOstJZbijERDLeai4kQA/FK9saQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jul 2013 11:58:53 +0530, Viresh Kumar wrote:

> On 4 July 2013 11:13, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > This is a possible solution, but I've already modified thermal code
> > a bit and found a solution for the problem.
> >
> > I use thermal workqueue (which is already in place anyway) to
> > enable the boost again.
> > Due to that I can provide behaviour similar to HW controlled boost.
> >
> > Patches with this solution are already prepared. I will post them
> > in a few hours. Ok?
> 
> I don't see any harm in checking them out :)
> Please send them.

:-)

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
