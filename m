Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab3BMDft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:35:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43965 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755195Ab3BMDfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:35:47 -0500
Message-ID: <1360726546.2220.6.camel@joe-AO722>
Subject: Re: [PATCH v2 2/6] mfd: Add ChromeOS EC implementation
From: Joe Perches <joe@perches.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Date: Tue, 12 Feb 2013 19:35:46 -0800
In-Reply-To: <1360723347-28701-3-git-send-email-sjg@chromium.org>
References: <1360723347-28701-1-git-send-email-sjg@chromium.org>
	 <1360723347-28701-3-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 18:42 -0800, Simon Glass wrote:
> This is the base EC implementation, which provides a high level
> interface to the EC for use by the rest of the kernel. The actual
> communcations is dealt with by a separate protocol driver which
> registers itself with this interface.

trivial logging message comments...

> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
[]
> +struct cros_ec_device *cros_ec_alloc(const char *name)
> +{
> +	struct cros_ec_device *ec_dev;
> +
> +	ec_dev = kzalloc(sizeof(*ec_dev), GFP_KERNEL);
> +	if (ec_dev == NULL) {
> +		dev_err(ec_dev->dev, "cannot allocate\n");

allocation OOM messages aren't useful as there's
a standard one on all allocs without __GFP_WARN

> +int cros_ec_register(struct cros_ec_device *ec_dev)
> +{
[]
> +		ec_dev->din = kmalloc(ec_dev->din_size, GFP_KERNEL);
> +		if (!ec_dev->din) {
> +			err = -ENOMEM;
> +			dev_err(dev, "cannot allocate din\n");

etc...

> +	if (err) {
> +		dev_err(dev, "failed to add mfd devices");

missing terminating newline


