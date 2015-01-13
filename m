Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbbAMFHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:07:21 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:49897 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbAMFHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:07:20 -0500
Date: Mon, 12 Jan 2015 21:07:15 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com,
        Angus Clark <angus.clark@st.com>,
        Carmelo Amoroso <carmelo.amoroso@st.com>
Subject: Re: [PATCH v3 08/13] mtd: st_spi_fsm: Update the JEDEC probe to
 handle extended READIDs
Message-ID: <20150113050715.GQ9759@ld-irv-0074>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <1418644760-18773-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418644760-18773-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:59:15AM +0000, Lee Jones wrote:
> The previous code was based on 3-byte JEDEC IDs, with a possible 2-byte
> extension.  However, devices are now emerging that return 6 or more bytes of
> READID data and the additional bytes are required to differentiate between
> variants or generations of similar devices.
> 
> This patch refactors the device table and JEDEC probe code to handle arbitrary
> length READIDs, with the standard JEDEC definition now becoming a special case.
> Functionally, there should be no change in behaviour.  A subsequent patch will
> update the table with extended READIDs where applicable.

BTW, how's that promise going, where you work on adapting this driver to
the spi-nor framework? We've already done some of this same work there.

> +#define RDID(...) __VA_ARGS__  /* Dummy macro to protect array argument. */

What? What needs "protected"?

...

Brian
