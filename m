Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaJaJde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:33:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24876 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJaJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:33:32 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-84-54535768d675
Content-transfer-encoding: 8BIT
Message-id: <1414748006.7705.2.camel@AMDC1943>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 31 Oct 2014 10:33:26 +0100
In-reply-to: <CAPDyKFpz2Finv0BUmp1pQtihUzUULCfj7hmOJW3CJ_cWErLySQ@mail.gmail.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
 <1414746895.6797.3.camel@AMDC1943>
 <CAPDyKFpz2Finv0BUmp1pQtihUzUULCfj7hmOJW3CJ_cWErLySQ@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4Nd2M8OAQg6vvJCw2zljPavHkQDuj
	xfSpFxgtVk/9y2pxtukNu8WSyfNZLWZN2ctksbBtCYvF5V1z2Cw+9x5htLh9mddi7ZG77Bbv
	XkZY3D11lM3izOlLrBYTfl9gszi+NtziZd9+Fgchj5bmHjaPxXteMnncubYHyOqbzOqx5M0h
	Vo8tV9tZPGbf/cHo0bdlFaPHitXf2T0+b5Lz2Pv5N0sAdxSXTUpqTmZZapG+XQJXxtpLz5kK
	2rgqjq+8wdTA+Iu9i5GTQ0LAROLFjsesELaYxIV769m6GLk4hASWMkrMP7qDCSTBKyAo8WPy
	PZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqP/MKLFi6hpGiHo9iYNbroANFRYIl7i/bAuYzSZg
	LLF5+RI2EFtEQENiz8PzrCDNzAJPWCVu3JkJtoxFQFViyf5FYEWcAsES71p+skNs+MgocXHN
	T7ArJASUJRr73SYwCsxCct8shPtmIblvASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ
	SPyyg3HxMatDjAIcjEo8vCskg0OEWBPLiitzDzFKcDArifCKuAOFeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MDp+OPk/8rvQ3F+/1T/O+xUWsjj+pfv1/vM1LlkLJkrtzw/p77aXaP2l8jkydMak
	/YvWfj6Vrjpj14vdHZNLrzY4FPoxXXGYatgTvUjn5ywzrur7sxxaL4QH71Tur/YsOL/22bqp
	TOcUsjS9ORxZC7/US81UO/0omfVM71PtM9f/S85dc0mA20mJpTgj0VCLuag4EQBDp5CBogIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 10:29 +0100, Ulf Hansson wrote:
> On 31 October 2014 10:14, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> >> Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> >> PM IRQ safe was set or not.
> >>
> >> Various bus drivers implementing runtime PM may use choose to suspend
> >> differently based on IRQ safeness status of child driver (e.g. do not
> >> unprepare the clock if IRQ safe is not set).
> >>
> >> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > Rafael, Len, Pavel,
> >
> > Is proposed API ok? Do you have any comments?
> >
> > I'll upload whole patchset to Russell's patch tracking system. However
> > an ack from PM maintainer is probably needed.
> 
> I would actually prefer the opposite. It's better if we can take these
> patches through Rafaels tree.
> 
> 1) I have posted patches for the amba bus, these may have merge
> conflicts with your changes.
> 2) We may start using the new runtime PM API within genpd as of now.

I don't mind and it makes sense to me.
This way I need an ack from Russell or Vinod...


Best regards,
Krzysztof


