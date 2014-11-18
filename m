Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaKRAXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:23:13 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58720 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaKRAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:23:12 -0500
Message-ID: <1416270188.18197.16.camel@gmail.com>
Subject: Re: [PATCH] staging: lustre: mdc: use __FMODE_EXEC macro
From: Juston <juston.h.li@gmail.com>
Reply-To: 20141117224616.GI4905@mwanda
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org
Date: Mon, 17 Nov 2014 16:23:08 -0800
In-Reply-To: <20141117224616.GI4905@mwanda>
References: <1416263028-16026-1-git-send-email-juston.h.li@gmail.com>
	 <20141117224616.GI4905@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 01:46 +0300, Dan Carpenter wrote:
> On Mon, Nov 17, 2014 at 02:23:48PM -0800, Juston Li wrote:
> > FMODE_EXEC is type fmode_t but is used in operations
> > with integers which leads to sparse warnings:
> > drivers/staging/lustre/lustre/mdc/mdc_lib.c:198:21: warning: restricted fmode_t degrades to integer
> > drivers/staging/lustre/lustre/mdc/mdc_locks.c:300:49: warning: restricted fmode_t degrades to integer
> > 
> > Fix by using __FMODE_EXEC macro defined in fs.h.
> > 
> > Note the same warnings occurs with other fmode flags
> > here but they don't have a corresponding int macro.
> > 
> 
> When are FMODE_EXEC and __FMODE_EXEC not defined?  I think they're
> always defined.  I don't understand the point of these ifdefs.  I guess
> maybe they are for compatability with obsolete kernels?
> 
> regards,
> dan carpenter
> 
Seems to be the case. Looked at some old commits (2.6.17) and found
FMODE_EXEC was mainlined to allow lustre to be installed on a vanilla
kernel.
Since you pointed it out, if we are dealing with compatability with 
obselete kernels, __FMODE_EXEC was added later in 2.6.38. Wondering
if I should address the case where FMODE_EXEC is defined but 
__FMODE_EXEC isn't since I currently only check __FMODE_EXEC.

Regards,
Juston Li

