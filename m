Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968279Ab3DRKw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:52:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33749 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967301Ab3DRKwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:52:55 -0400
Date: Thu, 18 Apr 2013 11:52:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Laurent Meunier <laurent.meunier@st.com>
Subject: Re: [PATCH v3] pinctrl/pinconfig: add debug interface
Message-ID: <20130418105246.GO14496@n2100.arm.linux.org.uk>
References: <1366281314-14613-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366281314-14613-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:35:14PM +0200, Linus Walleij wrote:
> +		if (map->type != dbg->map_type)
> +			continue;
> +		if (!!strcmp(map->dev_name, dbg->dev_name))

!! is pointless in this context - if() evaluates any non-zero value as
true, so there's no point making the code more complicated by trying to
convert it to a false/true value first.
