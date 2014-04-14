Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaDNPr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:47:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58645 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDNPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:47:25 -0400
Message-ID: <534C030A.80602@wwwdotorg.org>
Date: Mon, 14 Apr 2014 09:47:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>,
        Tim Kryger <tim.kryger@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [rfc]pwm: add BCM2835 PWM driver
References: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be>	<CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>	<5344A209.7010507@wwwdotorg.org> <CAAYSxhqv_RLfksBE-n8KMg33v6ZfB4B4E8NQUYf8JsPzVrLYzw@mail.gmail.com> <534BB90B.7030904@thomasmore.be>
In-Reply-To: <534BB90B.7030904@thomasmore.be>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 04:31 AM, Bart Tanghe wrote:
> Is it the responsibility of the pwm driver to handle the pinmux of the
> io pins? Or is the end user, or a parent driver responsible to handle this?
> Idem for the clock?

The pinmux driver is responsible for writing to the pinmux registers.
This can be set up either statically so it happens at system boot, or
dynamically so that it's triggered by the SPI/... driver. Statically is
preferred uneless there's a need to change the pinmux back/forth between
different configurations at run-time.

Any clock programming should be performed by a clock driver. We don't
have one of those upstream yet, mainly because it would rely on talking
to the firmware (running on the VideoCore) to manipulate the clocks, and
we don't have a firmware protocol driver either.
