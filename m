Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaDYOTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:19:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58958 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaDYOTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:19:13 -0400
Date: Fri, 25 Apr 2014 09:15:51 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC PATCH] mfd: pm8x41: Naive function devices registration
Message-ID: <20140425141551.GL5546@joshc.qualcomm.com>
References: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:32:51PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Currently functions that exist in both the controller at the
> same address offset can not be specified with the same names.

The terminology here is a bit confusing.  When I read "controller", I
hear "SPMI controller", but this is really not a limitation of the SPMI
core, but rather a limitation of of_platform_populate() used by this
particular SPMI slave MFD driver.

> Adding Unique Slave ID device address to prefix function
> device names fixes this.
> 
> Function devices are SPMI devices, so register them on
> SPMI bus.

This is a step backwards.  The PMIC functions are not individually
addressable SPMI slaves, and as such should not be represented as
independent devices to the SPMI core.

They really are subfunctions of a particular SPMI slave, and should be
modeled as children of that slave device.  With this driver, we've
chosen to model the child devices as platform devices, but it could
also be a separate bus type.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
