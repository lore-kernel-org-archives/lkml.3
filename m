Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaF2JsL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:48:11 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50607 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaF2JsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:48:09 -0400
Date: Sun, 29 Jun 2014 11:46:43 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] regulator: act8865: set correct number of regulators
 in pdata
Message-ID: <20140629094642.GA13485@gmail.com>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
 <20140627160725.GQ23300@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627160725.GQ23300@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:07:25PM +0100, Mark Brown wrote:
> On Sun, Jun 22, 2014 at 05:31:42PM +0200, Beniamino Galvani wrote:
> > When platform data is populated from DT all the regulators are
> > instantiated and the value of num_regulators should be the number of
> > all available regulators rather than the number of matched ones.
> 
> Could you go into more detail on your logic on this one please?  The
> platform data (and DT configuration) for regulators should be completely
> optional.

pdata contains an array of struct act8865_regulator_data and a
num_regulators field which should hold the number of elements in the
array, if I understand correctly.

So in the current code, when populating platform data from DT, there
is a mismatch between the number of elements that are put in the array
(ARRAY_SIZE(act8865_matches)) and the value of num_regulators, which
is set to the number of regulators found in the DT.

In case of missing regulator nodes in DT, pdata->regulators will be
populated with all the regulators but their init_data will be NULL.

Beniamino
