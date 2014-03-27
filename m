Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaC0FqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:46:16 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50586 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaC0FqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403270639510.10699@ionos.tec.linutronix.de>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
	<3c77c9453e42b7a914c15ef67a8ee142d3543a48.1395897612.git.viresh.kumar@linaro.org>
	<aa0ab84ff46cdc4a2d7aef475b2c032009f23d29.1395897612.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1403270639510.10699@ionos.tec.linutronix.de>
Date: Thu, 27 Mar 2014 11:16:14 +0530
Message-ID: <CAKohpomG58xGMBLDCmKjXadBuX9Y8EEPcfnGZNFN8mgK_PB9zA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] hrtimer: use __ffs() to iterate over valid bits
 from active_bases
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2014 11:10, Thomas Gleixner <tglx@linutronix.de> wrote:
> What if this is a spurious interrupt and active_bases is 0?

Hmm.. haven't thought about that actually.. I thought it would be
guaranteed here that active_bases isn't zero.

Will fix it as the current code would end up in a infinite loop.
