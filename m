Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaEENpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:45:24 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61179 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbaEENpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:45:22 -0400
Date: Mon, 5 May 2014 09:45:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: put_user: fix possible data corruption in
 put_user
In-Reply-To: <53676D12.9040300@samsung.com>
Message-ID: <alpine.LFD.2.11.1405050944001.980@knanqh.ubzr>
References: <1399270438-26181-1-git-send-email-a.ryabinin@samsung.com> <20140505090126.GD3693@n2100.arm.linux.org.uk> <53676D12.9040300@samsung.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Andrey Ryabinin wrote:

> On 05/05/14 13:01, Russell King - ARM Linux wrote:
> > On Mon, May 05, 2014 at 10:13:58AM +0400, Andrey Ryabinin wrote:
> >> According to arm procedure call standart r2 register is call-cloberred.
> >> So after the result of x expression was put into r2 any following
> >> function call in p may overwrite r2. To fix this, the result of p
> >> expression must be saved to the temporary variable before the
> >> assigment x expression to __r2.
> > 
> > This and the patch make no sense.  You talk about r2, but you're doing
> > nothing with r2 in the patch.
> > 
> 
> No, you didn't get it. I'll try to explain better.
> 
> Lets consider following example:
[...]

Thanks for the test code.  I do confirm there is indeed a problem.

I'm trying to make sure your patch is actually the best fix.


Nicolas
