Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3CUPC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:02:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38176 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752809Ab3CUPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:02:58 -0400
Date: Thu, 21 Mar 2013 11:02:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
cc: myungjoo.ham@samsung.com, <rjw@sisk.pl>, Kevin Hilman <khilman@linaro.org>,
        <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM / devfreq: tie suspend/resume to runtime-pm
In-Reply-To: <1363872506-3630-3-git-send-email-rajagopal.venkat@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1303211101530.1899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Rajagopal Venkat wrote:

> Allow device devfreq to be suspend/resume automatically with
> runtime pm suspend/resume. The devfreq drivers should be least
> cared when to suspend/resume the devfreq.
> 
> pm_runtime_suspend(dev) will first suspend device devfreq(if available)
> before device is suspended from runtime pm core.
> 
> pm_runtime_resume(dev) will resume device devfreq(if available) after
> device is resumed from runtime pm core.

Aren't these backward?  The device continues to need its clocks and 
frequency settings until _after_ it has been suspended.  Similarly, it 
needs them to be available _before_ it resumes.

Alan Stern

