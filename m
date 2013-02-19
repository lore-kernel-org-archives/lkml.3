Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3BSTc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:32:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58874 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab3BSTcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:54 -0500
Message-ID: <5123D362.4000702@wwwdotorg.org>
Date: Tue, 19 Feb 2013 12:32:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
References: <1361015443.11226.1.camel@phoenix> <5123ACA1.9000408@wwwdotorg.org> <20130219182647.GD23508@opensource.wolfsonmicro.com>
In-Reply-To: <20130219182647.GD23508@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:26 AM, Mark Brown wrote:
> On Tue, Feb 19, 2013 at 09:47:29AM -0700, Stephen Warren wrote:
>> On 02/16/2013 04:50 AM, Axel Lin wrote:
> 
>>> Ignore the setting and show "Only SM0/SM1 can set slew rate"
>>> warning is enough, then we can return 0 instead of -EINVAL in
>>> tps6586x_regulator_set_slew_rate().
>>> 
>>> Otherwise, probe() fails.
> 
>> Why does probe() fail; what is trying to set a slew rate on a
>> regulator that doesn't support it? At least a few days ago in
>> linux-next, this patch wasn't needed AFAIK. Is the problem
>> something new?
> 
> I rather suspect Axel is doing this based on code inspection and
> review rather than testing (either that or he has an enormous lab
> somewhere full of all sorts of hardware!)

Makes sense.

> - what he's saying is that the error handling here seems
> excessive.

Why shouldn't the driver return an error if it's asked to do something
that's impossible?
