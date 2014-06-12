Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaFLVRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:17:07 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45811 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaFLVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:17:05 -0400
Date: Thu, 12 Jun 2014 14:17:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lan Tianyu <tianyu.lan@intel.com>
cc: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
In-Reply-To: <53996152.2000407@intel.com>
Message-ID: <alpine.DEB.2.02.1406121415150.8305@chino.kir.corp.google.com>
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com> <53996152.2000407@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Lan Tianyu wrote:

> The retry time is set by randomly and not accurate because don't know
> when EC will work normally. Set the retry time to 5 just in order to
> make sure battery driver probing sucessfully every time,
> 

Ok, I was hoping to avoid the excessive wait if it will never actually 
succeed but I assume there's some evidence that it can succeed after 40ms, 
60ms, etc.  Please consider the following instead:

	for (i = 0; i < 5; i++) {
		/* Comment on why we need a delay in between retries */
		if (i)
			msleep(20);
		result = acpi_battery_update(battery, false);
		if (!result)
			break;
	}
