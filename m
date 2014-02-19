Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaBSD1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:27:34 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60626 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBSD1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:27:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140219021246.GK15716@S2101-09.ap.freescale.net>
References: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com>
	<CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
	<20140219021246.GK15716@S2101-09.ap.freescale.net>
Date: Wed, 19 Feb 2014 08:57:32 +0530
Message-ID: <CAK9yfHw2q-PSaUS_tApxN=tsBhN33n6ghgTmpSJVP5yJYDQgWA@mail.gmail.com>
Subject: Re: [PATCH] pfuze100-regulator: Revert "regulator: pfuze100: Use of_get_child_by_name"
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>, festevam@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 07:42, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Feb 18, 2014 at 09:58:52PM +0530, Sachin Kamat wrote:
>> On 18 February 2014 21:20, Fabio Estevam <fabio.estevam@freescale.com> wrote:
>> > Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
>> > the following probe failure:
>> >
>> > pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
>> > pfuze100-regulator 1-0008: FAB: 0, FIN: 0
>> > pfuze100-regulator 1-0008: regulators node not found
>> > pfuze100-regulator: probe of 1-0008 failed with error -22
>> >
>> > Revert the offending commit so that we can probe the regulator successfully.
>>
>> I wonder what is different in this case from the ones that I already
>> have working
>> that is causing this to fail. Can you please tell me which dts file
>> you have used
>> so that I can see if the way the node is defined is anything different.
>
> When you change to use of_get_child_by_name(), you should change 'np' to
> point to dev->of_node too.

Thanks for the tip Shawn. Coincidentally all the ones that I tested
had this (np pointing
to dev->of_node) already. So I happened to miss out on this check.

-- 
With warm regards,
Sachin
