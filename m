Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3KDJVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:21:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab3KDJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:21:03 -0500
Date: Mon, 4 Nov 2013 09:21:02 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] extcon: arizona: Fix reset of HPDET after race
	with removal
Message-ID: <20131104092102.GC30879@opensource.wolfsonmicro.com>
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5276EB32.9060803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5276EB32.9060803@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:32:50AM +0900, Chanwoo Choi wrote:
> The arizona_hpdet_do_id() return only either -EAGIN or 0(zero).
> extcon-arizona driver could never execute 'goto done;' statement.
> 
> 	ret = arizona_hpdet_do_id(info, &reading, &mic);
> 	if (ret == -EAGAIN) {
> 		goto out;
> 	} else if (ret < 0) {
> 		goto done;
> 	}

True that else if is redundant at the moment, but personally I
would be inclined to leave it in, it feels safer against possible
future edits of arizona_hpdet_do_id. It would be reasonable for
someone to assume that other return values are acceptable whilst
editing it but they would then not be handled.

Thanks,
Charles
