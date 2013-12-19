Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3LSP3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:29:30 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46312 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708Ab3LSP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:29:28 -0500
Message-ID: <1387466965.2210.9.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 17/38] parisc: kernel: add missing put_device call
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Helge Deller <deller@gmx.de>,
        Chen Gang <gang.chen@asianux.com>, linux-parisc@vger.kernel.org
Date: Thu, 19 Dec 2013 07:29:25 -0800
In-Reply-To: <1387465429-3568-18-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	 <1387465429-3568-18-git-send-email-levex@linux.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 16:03 +0100, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.

No, it's not.  And the subject is misleading at best, since this isn't
any form of problem in the code.

If the add fails, the device isn't visible in sysfs and no references
have been handed out.  We're perfectly entitled to follow the common
pattern of simply destroying it at this point rather than going through
the nascent refcounting.

James


