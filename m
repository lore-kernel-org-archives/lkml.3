Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab3K1HSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:18:10 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:43671 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3K1HSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:18:08 -0500
Date: Thu, 28 Nov 2013 08:18:06 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: =?utf-8?B?7ZeI7KKF66eM?= <jongman.heo@samsung.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.13.0-rc1+ INFO: inconsistent lock state
Message-ID: <20131128071806.GE20630@order.stressinduktion.org>
Mail-Followup-To: =?utf-8?B?7ZeI7KKF66eM?= <jongman.heo@samsung.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <13025162.118881385612276530.JavaMail.weblogic@epv6ml01>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13025162.118881385612276530.JavaMail.weblogic@epv6ml01>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:17:56AM +0000, 허종만 wrote:
> With current linus git (HEAD 8ae516aa), I got following kernel message.
> This is slightly different from what I had reported recently (14th Nov).

I guess the prolem is that the STATS _BH functions are to be used if they
are executed in bottom half and maybe people expect it to protect against
bottom half. We seem to have some more of this problems in udp_sendmsg
(this trace) and ping_sendmsg, maybe in tcp, too. The non-_BH functions
actually disable bh.

I'll check for more prolems and will post a patch.

Thanks for reporting,

  Hannes

