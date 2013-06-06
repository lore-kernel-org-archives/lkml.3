Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FFUcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:32:09 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47956 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3FFUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
Date: Thu, 6 Jun 2013 23:32:06 +0300
Message-ID: <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:33 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
> There is a requirement to get the i2c_client pointer dynamically without
> knowing the bus and slave address. But we do know the client name,
> i.e. the name in the i2c_board_info. This patch is to fit this requirement.
>
> A good example is that an ISP(Imaging Signal Processor) driver needs
> register i2c camera sensor devices via v4l2, so it has to unregister
> all i2c clients that were previously registered by calling
> i2c_register_board_info(), and then re-register. For this case we
> can use this helper to get i2c_client by passing the client name.

Why ISP driver would like to register sensor drivers in the first place?
That seems the task of platform code, or DT, or ACPI5

Why do you need to re-register them at run time?

--
With Best Regards,
Andy Shevchenko
