Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaAKEPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:15:25 -0500
Received: from mail-oa0-f68.google.com ([209.85.219.68]:48725 "EHLO
	mail-oa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaAKEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:15:22 -0500
MIME-Version: 1.0
Date: Sat, 11 Jan 2014 12:15:21 +0800
Message-ID: <CAK=oMXebE=OKzGbaRH_baOvRyhPXnw0MZuRrcZYLpeR73=XdqA@mail.gmail.com>
Subject: [Question] Should we make the primary interrupt handler configurable
 for regmap_add_irq_chip()?
From: Yi Zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, hongfeng@marvell.com,
        linux-kernel@vger.kernel.org, zhouqiao@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark:

Sorry to trouble you;
I have a question about the regmap_add_irq_chip():
at present, we use the default primary interrupt handler to handle the
parent interrupt from a mfd device;

I met a scenario:
As soon as the interrupt is triggered, a wakelock is needed to be held
until the threaded handler finishes,
I think we may hold it in the primary interrupt handler, but now it's
NULL by default;

so could we make the the primary interrupt handler configurable? for
example, add a parameter to regmap_add_irq_chip(),
then the user can choose to use current solution or his/her own handler;

what do you think?
could you please share your opinion?

thanks very much;
