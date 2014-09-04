Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaIDRPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:15:17 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39077 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbaIDRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <54045FA6.70602@mentor.com>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
	<20140829190129.GZ29327@sirena.org.uk>
	<5404246E.4090908@de.bosch.com>
	<20140901101512.GK29327@sirena.org.uk>
	<54045FA6.70602@mentor.com>
Date: Thu, 4 Sep 2014 19:15:13 +0200
Message-ID: <CACRpkdZXDf0CX5yH3inoi4zu_gZ5-B9eMDY6aDN9b8m=rD61vw@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Cc: Mark Brown <broonie@kernel.org>, Dirk Behme <dirk.behme@de.bosch.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 1:59 PM, Dmitry Eremin-Solenikov
<dmitry_eremin@mentor.com> wrote:

> Back in the time before DTS conversion started, the 0 was a correct GPIO
> number. If somebody wanted to specify that no gpio is provided, he provided
> -1 as an invalid number. I have the feeling that allowing users to use 0 as
> 'no gpio' is a mistake. Or the API should be changed
> to disallow GPIO 0 to exist at all.

The API change that is going on is to switch platforms and subsystems
to only deal with GPIO descriptors, which are pointer cookies such as
is regulators and clocks. See Documentation/gpio/*

Fixing the old global GPIO numberspace API is a waste of time IMO,
it is just restricted by design and we want to get rid of it.

Yours,
Linus Walleij
