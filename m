Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaIFCm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:42:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIFCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:42:56 -0400
Date: Fri, 5 Sep 2014 19:42:54 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
Message-ID: <20140906024253.GB11389@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:14:05AM -0600, Azael Avalos wrote:
> The accelerometer sensor is very sensitive, and having userspace
> poll the sysfs position entry is not very battery friendly.
> 
> This patch removes the sysfs entry and instead, it creates an
> input polled device (joystick) for the built-in accelerometer.

Hrm, while sysfs details can change across kernel versions, usually due to
driver core changes, we try to keep them as consistent as possible so as not to
break userspace.

That said, if we are going to try and come up with a better model for
representing an accelerometer, wouldn't treating it as an IIO device be the more
logical approach?

-- 
Darren Hart
Intel Open Source Technology Center
