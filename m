Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaGBRSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:18:42 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37178 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaGBRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <53B141B9.2060401@de.bosch.com>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
	<1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
	<53B141B9.2060401@de.bosch.com>
Date: Wed, 2 Jul 2014 11:18:39 -0600
Message-ID: <CANLsYkzEHCyPJNfWVKOq-=LU73FN=G7fkqWmKKPcLQB1idFKQA@mail.gmail.com>
Subject: Re: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        Robert Marklund <robbelibobban@gmail.com>, Al Grant <Al.Grant@arm.com>,
        Patch Tracking <patches@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        r.sengupta@samsung.com,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James King <james.king@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 04:53, Dirk Behme <dirk.behme@de.bosch.com> wrote:
> On 27.06.2014 20:04, mathieu.poirier@linaro.org wrote:
>>
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> CoreSight components are compliant with the ARM CoreSight
>> architecture specification and can be connected in various
>> topologies to suite a particular SoCs tracing needs. These trace
>> components can generally be classified as sources, links and
>> sinks. Trace data produced by one or more sources flows through
>> the intermediate links connecting the source to the currently
>> selected sink.
>>
>> CoreSight framework provides an interface for the CoreSight trace
>> drivers to register themselves with. It's intended to build up a
>> topological view of the CoreSight components and configure the
>> right series of components on user input via debugfs.
>>
>> For eg., when enabling a source, framework builds up a path
>> consisting of all the components connecting the source to the
>> currently selected sink and enables all of them.
>>
>> Framework also supports switching between available sinks and
>> also provides status information to user space applications
>> through the debugfs interface.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Panchaxari Prasannamurthy
>> <panchaxari.prasannamurthy@linaro.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>   .../devicetree/bindings/arm/coresight.txt          | 141 +++++
>>   drivers/Kconfig                                    |   2 +
>
>
> I wonder if
>
> arch/arm/Kconfig.debug
>
> wouldn't be better place for this?

With the other kernel hacking options - right, that is probably best.

>
> Best regards
>
> Dirk
