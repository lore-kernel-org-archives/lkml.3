Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078Ab3ARGOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:14:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56967 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab3ARGOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:14:06 -0500
Date: Fri, 18 Jan 2013 15:13:59 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: wm8994: Convert wm8994_ldo2_ops to use
 regulator_list_voltage_linear
Message-ID: <20130118061357.GA4960@opensource.wolfsonmicro.com>
References: <1358481513.25899.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358481513.25899.6.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:58:33AM +0800, Axel Lin wrote:

> +	/* LDO2, id starts from 0 */
> +	if (id == 1) {
> +		switch (wm8994->type) {
> +		case WM8994:
> +			wm8994_ldo_desc[id].min_uV = 900000;
> +			wm8994_ldo_desc[id].uV_step = 100000;
> +			break;

This isn't going to work in the (admittedly unlikely) case where we have
two different devices using this driver in the system.  We shouldn't be
modifying static data like this.
