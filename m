Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaIHOPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:15:52 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:57424
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294AbaIHOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:15:48 -0400
Date: Mon, 8 Sep 2014 09:15:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Nicolas Pitre <nicolas.pitre@linaro.org>
cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
In-Reply-To: <alpine.LFD.2.11.1409051525440.16533@knanqh.ubzr>
Message-ID: <alpine.DEB.2.11.1409080914370.20388@gentwo.org>
References: <20140901230728.GM29327@sirena.org.uk> <1627064.QhxvejlWdk@amdc1032> <alpine.DEB.2.11.1409020857110.9201@gentwo.org> <alpine.DEB.2.11.1409020958530.9608@gentwo.org> <alpine.LFD.2.11.1409051525440.16533@knanqh.ubzr>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Nicolas Pitre wrote:

> > -	return raw_cpu_read(base->percpu_base);
> > +	return raw_cpu_read(*base->percpu_base);
>
> Isn't the pointer dereference supposed to be performed _outside_ the per
> CPU accessor?

It looks like percpu_base is a regular pointer to an offset. This is the
correct way to refer to get the offset and load the value that the offset
points to.

