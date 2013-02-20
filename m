Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab3BTWMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:12:39 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:46674 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3BTWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:12:38 -0500
MIME-Version: 1.0
In-Reply-To: <512549BE.70304@oracle.com>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
	<CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
	<512522CF.1020901@oracle.com>
	<20130220210116.GD3570@htj.dyndns.org>
	<20130220132300.ccffde44.akpm@linux-foundation.org>
	<20130220213701.GE3570@htj.dyndns.org>
	<20130220140551.8017e795.akpm@linux-foundation.org>
	<512549BE.70304@oracle.com>
Date: Wed, 20 Feb 2013 14:12:37 -0800
X-Google-Sender-Auth: 6iRk2yLGEe28Ts8iKJ766FJjpRM
Message-ID: <CAOS58YM77VdO9EoH-5LKZ0NBR0d41GE900goqktU29Oi5=Ov8g@mail.gmail.com>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:10 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> I do think that if you have to resort to using something like that there's
> something terribly wrong with the code somewhere else, and that other thing
> should be fixed first.
>
> Maybe digging into the timers code and seeing why this is needed there will
> prove me wrong...

The problem is that userland can feed us any timer_t which makes it
necessary to properly sanitize the value before using it.

Thanks.

-- 
tejun
