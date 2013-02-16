Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3BPUuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 15:50:01 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38801 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3BPUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 15:49:58 -0500
Date: Sat, 16 Feb 2013 12:49:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Mike A. Chan" <mikechan@google.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v4 6/6] Input: Add ChromeOS EC keyboard driver
Message-ID: <20130216204954.GA22044@core.coreip.homeip.net>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
 <1360988172-15380-7-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360988172-15380-7-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Fri, Feb 15, 2013 at 08:16:12PM -0800, Simon Glass wrote:
> +	for (row = 0; row < ckdev->rows; row++) {
> +		if (cros_ec_keyb_row_has_ghosting(ckdev, buf, row))
> +			return true;
> +	}

No need for curly braces here. I would not care if not for below.

> +
> +	return 0;
> +
> +fail_register:
> +	kfree(idev->keycode);

Sorry I did not notice this before, but idev->keycode is devm-managed,
so you either need to use devm_kfree() or just remove call to kfree()
and let it clean up automatically (which will happen if binding fails or
upon removal).

BTW, maybe you should move the whole driver to devm_*? We have
devm_kzalloc() for ckdev and you can use devm_input_allocate_device().
Then you can get rid of entire erro handling path and completely remove
the remove() method as well.
 
> +fail_matrix:
> +	input_free_device(idev);
> +fail_alloc_dev:
> +	kfree(ckdev);
> +	return err;
> +}
> +

Thanks.

-- 
Dmitry
