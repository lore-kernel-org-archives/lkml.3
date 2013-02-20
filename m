Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935294Ab3BTLOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:14:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935115Ab3BTLOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:14:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dong Aisheng <dong.aisheng@linaro.org>
Subject: Re: Re[8]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 11:14:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201006.41287.arnd@arndb.de> <CAP1dx+xj3+PVu98pRBAOhLxvOzhwE7VNShMLmqk-jy_CgXh8GA@mail.gmail.com>
In-Reply-To: <CAP1dx+xj3+PVu98pRBAOhLxvOzhwE7VNShMLmqk-jy_CgXh8GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201114.49304.arnd@arndb.de>
X-Provags-ID: V02:K0:ivsqPC5Mh8HdpC0OQibNERtSyzSpgbZFnrcFGmBv1X6
 VNwse5ZTG5Gvo1U1PORCZGLwhmQx8jt8Bh6GhEK+EKGGtUCZW2
 D87EDYCQMCMK9iKMWhMUgFQUWM4Bb+34KIvozO46MgU1MMOL6Y
 aYGrxp1kCPIdma53/rN044n29W6YPHVYyos98J5VqoCIgQKN/i
 oOM70KS9L/tErlCNDXz7Ep/hHPAePvdKcEvvxzYhCPJhIq1xWI
 XeKag4pkmX/gHAHsYa0wbELNPnLhvlajRuRR6FkzpbXFRl6SXT
 EiNUnj5o21w3fNNpXWfUDe5thGMx2lD1wRcZVt1QIgUn+raaeA
 aNsInkkm6h4DLrpejQKk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Dong Aisheng wrote:
> On 20 February 2013 18:06, Arnd Bergmann <arnd@arndb.de> wrote:
> > I would first like to get an answer to the question I asked in my first mail,
> > which is what the use case of non-DT support in this driver is. If this
> > is used only by a new platform that has to use DT anyway, or by an existing
> > platform that is easy enough to convert, we probably shouldn't do all this
> > at all.
> >
> 
> If the platform can convert to dt, then we do not have such issue.
> The question is do we allow the existing non-dt platforms to use it
> before converting?

I think the answer to that is "it depends". It's basically a question of
how much work it would be to convert the platforms that need it over to
DT, and how much of the interface it actually needs. E.g. if there is
only one in-tree platform that needs to use syscon but can't easily be
moved over to DT, but that platform can only have a single syscon device,
then we don't need any of the matching support but could simply return
the first regmap area we have in the list.

Of course, if the platform in question is out of tree, I would argue
that the whatever patches are needed by that platform should also
remain out of tree.

	Arnd
