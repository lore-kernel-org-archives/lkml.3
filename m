Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3LDTX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:23:58 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:41239 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab3LDTXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:23:53 -0500
MIME-Version: 1.0
In-Reply-To: <1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Wed, 4 Dec 2013 13:23:52 -0600
Message-ID: <CAL_JsqLNWRWxfD0qLsQ9crRa3_-TtykwUjuQvJQZC2E_xLhywg@mail.gmail.com>
Subject: Re: [PATCH v2] OF: base: match each node compatible against all given
 matches first
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Meelis Roos <mroos@linux.ee>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 7:52 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> Currently, of_match_node compares each given match against all node's
> compatible strings with of_device_is_compatible.
>
> To achieve multiple compatible strings per node with ordering from
> specific to generic, this requires given matches to be ordered from
> specific to generic. For most of the drivers this is not true and also
> an alphabetical ordering is more sane there.
>
> Therefore, this patch modifies of_match_node to match each of the node's
> compatible strings against all given matches first, before checking the
> next compatible string. This implies that node's compatibles are ordered
> from specific to generic while given matches can be in any order.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v1->v2:
> - Allow checks against nodes with no compatible (Reported by Rob Herring)
> - Add some comments
>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Meelis Roos <mroos@linux.ee>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Scott Wood <scottwood@freescale.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/of/base.c |   53 +++++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 37 insertions(+), 16 deletions(-)

Applied.

Rob
