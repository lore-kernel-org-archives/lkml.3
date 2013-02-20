Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab3BTL2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:28:43 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50585 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3BTL2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <201302201114.49304.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<201302201006.41287.arnd@arndb.de>
	<CAP1dx+xj3+PVu98pRBAOhLxvOzhwE7VNShMLmqk-jy_CgXh8GA@mail.gmail.com>
	<201302201114.49304.arnd@arndb.de>
Date: Wed, 20 Feb 2013 19:28:40 +0800
Message-ID: <CAP1dx+x_+jXTdWM2oH7JTBSQfy97hHkJVTmu8=3X_6iEiuAb4A@mail.gmail.com>
Subject: Re: Re[8]: [PATCH v3] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2013 19:14, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 20 February 2013, Dong Aisheng wrote:
>> On 20 February 2013 18:06, Arnd Bergmann <arnd@arndb.de> wrote:
>> > I would first like to get an answer to the question I asked in my first mail,
>> > which is what the use case of non-DT support in this driver is. If this
>> > is used only by a new platform that has to use DT anyway, or by an existing
>> > platform that is easy enough to convert, we probably shouldn't do all this
>> > at all.
>> >
>>
>> If the platform can convert to dt, then we do not have such issue.
>> The question is do we allow the existing non-dt platforms to use it
>> before converting?
>
> I think the answer to that is "it depends". It's basically a question of
> how much work it would be to convert the platforms that need it over to
> DT, and how much of the interface it actually needs. E.g. if there is
> only one in-tree platform that needs to use syscon but can't easily be
> moved over to DT, but that platform can only have a single syscon device,
> then we don't need any of the matching support but could simply return
> the first regmap area we have in the list.
>
> Of course, if the platform in question is out of tree, I would argue
> that the whatever patches are needed by that platform should also
> remain out of tree.
>

Basically i agree with your point.
Alexander seems to be the first non-dt user of syscon driver.
He may answer whether they could choose to convert to dt first.
But one question i wonder is that it may be hard to know how many poteintial
non-dt platforms may use syscon.

Regards
Dong Aisheng
