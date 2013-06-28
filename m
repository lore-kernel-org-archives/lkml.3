Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3F1MxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:53:25 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:47991
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab3F1MxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:53:24 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23hbe9i1155h)
Subject: Re: [patch v1 1/1]regulator: fix for DA9055 regulator
From: Ankur Raina <Ankur.Raina@kpitcummins.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.chen@diasemi.com" <david.chen@diasemi.com>
In-Reply-To: <20130628093359.GA27646@sirena.org.uk>
References: <4B6D9C89CD8BA349A71B74CA32C47E5850DA85DF@KCHJEXMB02.kpit.com>
	 <20130628093359.GA27646@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jun 2013 18:23:13 +0530
Message-ID: <1372423993.1604.15.camel@ankurr1-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.50.126]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 10:33 +0100, Mark Brown wrote:
> On Fri, Jun 28, 2013 at 07:05:03AM +0000, Ankur Raina wrote:
> > This patch adds support for usage of GPIO's by multiple bucks and regulators
> > of DA9055 for enable-disable and voltage set selection.Without this patch regulator
> > control through GPIO would fail for more than one regulator/buck.
> 
> This needs a much better patch description.  What specifically is the
> bug that you are trying to fix here?
The DA9055 hardware supports regulator control through GPIO for all its regulators and bucks.
For this, the contolling GPIO should be set as GPI.The current driver requests gpio for every regulator
that is gpio controlled.This request fails in case of a regulator requesting a gpio, which is already
been assigned to other regulators. The corresponding register update for that regulator also fails.
This patch fixes the above issue.


