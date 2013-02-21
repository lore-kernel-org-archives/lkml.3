Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3BUTtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:49:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56663 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3BUTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:49:31 -0500
Message-ID: <51267A46.8030105@wwwdotorg.org>
Date: Thu, 21 Feb 2013 12:49:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Joo <sjoo@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: use regulator name for sysfs
References: <1361433237-3217-1-git-send-email-sjoo@nvidia.com> <51267454.5040607@wwwdotorg.org> <20130221194302.GA16870@opensource.wolfsonmicro.com>
In-Reply-To: <20130221194302.GA16870@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 12:43 PM, Mark Brown wrote:
> On Thu, Feb 21, 2013 at 12:24:04PM -0700, Stephen Warren wrote:
>> On 02/21/2013 12:53 AM, Shawn Joo wrote:
> 
>>> regulator is named by numbering on sysfs, e.g. regulator.0,
>>> regulator.1 it confuses to find desired regulator before
>>> counting the order. add option for regulator name by
>>> use_name_onsysfs. if it is true and name is not NULL, desc's
>>> name will be the name. e.g. if name in desc is "LDO0", then
>>> regulator.LDO0 on sysfs. otherwise it follows origin.
> 
>> Does it make sense to make this change always, rather than based
>> on some new flag in regulator_desc?
> 
> It's certainly insane to change this based on the driver and given
> that sysfs is supposed to be an ABI it's questionable if we should
> do it at all.  We certainly can't use the descriptor name as that's
> very likely to clash if you have more than one PMIC.  Taking a
> glance through sysfs on my system what we're doing at the minute is
> pretty idiomatic, sysfs isn't really intended for humans but rather
> for machines to prettify.

Does the ABI describe just the layout of the sysfs filesystem, or also
the names of instances? Certainly the list of names of regulators
won't be in any ABI documentation. That said, I suppose for existing
platforms it'd probably be legitimate for someone to have looked there
and seen the names and assumed they would never change on that
particular platform, so changing them would break an implicit ABI.

>> Another place a similar change might be useful is debugfs.
> 
> debugfs already uses more human readable names, it uses the supply
> name (which is what we should be using if we were going to do
> anything as it really ought to be unique already).

Oh so it does. Was this a recent change? I could have sworn I saw lots
of regulator.n there, but perhaps I'm remembering sysfs.
