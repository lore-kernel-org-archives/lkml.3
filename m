Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab3AQJza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:55:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43720 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab3AQJz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:55:27 -0500
Message-ID: <50F7CA82.4050509@ti.com>
Date: Thu, 17 Jan 2013 10:55:14 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Luciano Coelho <coelho@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport power
 functions
References: <1358372702-13102-1-git-send-email-coelho@ti.com> <50F7C4A7.5060202@ti.com> <20130117093417.GH10814@arwen.pp.htv.fi>
In-Reply-To: <20130117093417.GH10814@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 10:34 AM, Felipe Balbi wrote:
>> I just wonder how this is going to work with DT... You are not going to have
>> the ability to use callback in this form.
>> I think the GPIO handling should be done in the driver itself rather than in
>> the board file.
> 
> that can (should ?) be moved to ti-st eventually. In fact I don't know
> why it was removed in the first place, we would need Pavan to help us
> with that query.

Yes, this is a good question. I don't know what is the spacial thing platforms
need to do in the callback..

> Still, for -rc, the minimal patch had to be cooked, right ?

Sure it need to be fixed. I would try to revert the patch which caused the
issue (eccf2979 drivers/misc/ti-st: remove gpio handling).

Should fix the legacy boot, but it is going to be even bigger fun to move to
DT (and get rid of the callbacks).

I don't have anything against this patch as such. Just wanted to point out the
obvious that the comfort of callbacks are not going to be around in some cases.

-- 
Péter
