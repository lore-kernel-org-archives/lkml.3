Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3A2Sqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:46:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40541 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3A2Sqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:46:45 -0500
Message-ID: <51081911.9070604@wwwdotorg.org>
Date: Tue, 29 Jan 2013 11:46:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument
 for calling of_regulator_match
References: <1358994450.20257.1.camel@phoenix> <1358994705.20257.4.camel@phoenix> <510711D1.3090205@wwwdotorg.org> <20130129033918.GA6878@opensource.wolfsonmicro.com>
In-Reply-To: <20130129033918.GA6878@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:39 PM, Mark Brown wrote:
> On Mon, Jan 28, 2013 at 05:03:29PM -0700, Stephen Warren wrote:
>> On 01/23/2013 07:31 PM, Axel Lin wrote:
>>> The dev parameter is the device requesting the data. In this
>>> case it should be &pdev->dev rather than pdev->dev.parent.
> 
>>> The dev parameter is used to call devm_kzalloc in
>>> of_get_regulator_init_data(), which means this fixes a memory
>>> leak because the memory is allocated every time probe() is
>>> called, thus it should be freed when this driver is unloaded.
> 
>> With this patch as part of next-20130128, I see a crash when
>> booting my system. Reverting this patch solves the problem.
> 
> Hrm, there's nothing obviously wrong with the code here - all we do
> with dev is call devm_kzalloc().  Can you decode where the crash is
> actually occurring, that might give a clue as to what's getting
> upset?  In the backtrace it's in regulator_register() but that's a
> pretty big function.

It looks like there's a bug in of_regulator_match() that this exposes.
I'll send a patch shortly.
