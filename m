Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3HPSxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:53:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3HPSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:52:57 -0400
Date: Fri, 16 Aug 2013 11:52:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 2/3] spmi: Add MSM PMIC Arbiter SPMI controller
Message-ID: <20130816185256.GC31510@kroah.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <2b97e8deb412ae0087bffe227690a26ea9dd9bba.1376596224.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b97e8deb412ae0087bffe227690a26ea9dd9bba.1376596224.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:37:07PM -0700, Josh Cartwright wrote:
> +struct spmi_pmic_arb_dev {
> +	struct spmi_controller	controller;
> +	struct device		*dev;
> +	struct device		*slave;

This is problematic.

Why do you have the driver "own" the controller?  What is dev for,
there's already a struct device within the controller.  Same for slave,
what is it?

You have 3 struct devices here, which one controls the lifecycle of the
object (hint, I know the answer, but I think it's wrong...)

thanks,

greg k-h
