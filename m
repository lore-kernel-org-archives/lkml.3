Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3EQR6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:58:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45529 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756530Ab3EQR6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:58:20 -0400
Message-ID: <1368813500.2194.83.camel@joe-AO722>
Subject: Re: [PATCH] drivers: mfd: sec-code: Fix sizeof argument
From: Joe Perches <joe@perches.com>
To: Leon Romanovsky <leon@leon.nu>
Cc: Samuel Ortiz <sameo@linux.intel.com>, sbkim73@samsung.com,
        linux-kernel@vger.kernel.org
Date: Fri, 17 May 2013 10:58:20 -0700
In-Reply-To: <CALq1K=J=Aeg11H5aX8bj-_EowdADJSg5oVY98c1q0v6YbhZEdg@mail.gmail.com>
References: <1368615236-21345-1-git-send-email-leon@leon.nu>
	 <20130516221321.GG22822@zurbaran>
	 <CALq1K=J=Aeg11H5aX8bj-_EowdADJSg5oVY98c1q0v6YbhZEdg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 20:50 +0300, Leon Romanovsky wrote:
> On Fri, May 17, 2013 at 1:13 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Wed, May 15, 2013 at 01:53:56PM +0300, Leon Romanovsky wrote:
> >> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
[]
> >> @@ -121,7 +121,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
[]
> >> -     pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> >> +     pd = devm_kzalloc(dev, sizeof(struct sec_platform_data), GFP_KERNEL);
> > How is that fixing anything ?
> Technically you are right, this fix brings code to be align to common
> code convention and allows to automatic tools  correctly parse it.

Not really.
Common coding convention is actually the original code.

from: Documentation/CodingStyle:

		Chapter 14: Allocating memory
[]
The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);


