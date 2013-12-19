Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3LSPeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:34:05 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55473 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LSPeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:34:02 -0500
MIME-Version: 1.0
In-Reply-To: <52B31158.3030801@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	<1387465429-3568-22-git-send-email-levex@linux.com>
	<20131219152044.GB16994@htj.dyndns.org>
	<52B31158.3030801@linux.com>
Date: Thu, 19 Dec 2013 10:34:00 -0500
X-Google-Sender-Auth: VjKSgml5bbVIUtJkTYHfrwNCAtY
Message-ID: <CAOS58YO7Ot69kv=2UOTDORMAtgL2EOq-voEj3JLCDb8Rv=LABA@mail.gmail.com>
Subject: Re: [PATCH 21/38] workqueue: add missing put_device call
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 19, 2013 at 10:31 AM, Levente Kurusa <levex@linux.com> wrote:
> The reason I removed the kfree() was because the put_device() will decrement
> wq_dev->dev's reference count to zero (it is set to one by device_register) and hence the
> wq_device_release() will be called. Now, this effectively does the same the kfree() call
> would have done but also driver core is notified.

Yeah, I know it does the same thing. It's just not the right way to do it.

> Also, if you take a look at the comment for the device_register() function, it explicitly
> says NOT to kfree the struct device, but instead call put_device() and let the device's release()
> function take care.

Greg, the API as described by the comment is really weird and
unconventional. Failed calls are not supposed to have side effects
which require explicit cleanup. Can we please update the comment?

Thanks.

-- 
tejun
