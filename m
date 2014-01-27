Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaA0E33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:29:29 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33360 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaA0E3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:29:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140127000300.GR11727@sirena.org.uk>
References: <1390673154-15839-1-git-send-email-badarkhe.manish@gmail.com>
	<20140126213653.GB18840@core.coreip.homeip.net>
	<20140127000300.GR11727@sirena.org.uk>
Date: Mon, 27 Jan 2014 09:59:12 +0530
Message-ID: <CAKDJKT6FVx+mZ1AvD1CuW66AfUJsF9BavsPJAMfgkBz1GMqz4A@mail.gmail.com>
Subject: Re: [PATCH] regulator: fixed: Use devm_regulator_register
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jan 27, 2014 at 5:33 AM, Mark Brown <broonie@kernel.org> wrote:
> On Sun, Jan 26, 2014 at 01:36:53PM -0800, Dmitry Torokhov wrote:
>> On Sat, Jan 25, 2014 at 11:35:54PM +0530, Manish Badarkhe wrote:
>
>> > Use "devm_regulator_register" instead of "regulator_register"
>> > which simplifies the code.
>
>> ... and also breaks the driver: now you are freeing desc->name and
>> desc->supply_name while regulator structures are still alive and can be
>> referenced from its sysfs attributes, etc.
>
> Yup, they need to be converted to managed allocations too if the
> regulator_register() is going to be converted (see previous discussions
> on similar patches).  It would be good to do so.

Thank you for pointing this out.
I missed to convert these two " desc->name" and "desc->supply_name"
to manage allocation. I will modify code and repost patch.

Regards
Manish Badarkhe
