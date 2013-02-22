Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3BVUfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:35:48 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35661 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3BVUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:35:45 -0500
Date: Fri, 22 Feb 2013 12:35:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Randy Dunlap <rdunlap@infradead.org>, James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH] ima: fix part_pack_uuid() build error
In-Reply-To: <1361562413.2908.22.camel@falcor1.watson.ibm.com>
Message-ID: <alpine.DEB.2.02.1302221232290.10081@chino.kir.corp.google.com>
References: <1361562413.2908.22.camel@falcor1.watson.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Mimi Zohar wrote:

> Fix a build error when CONFIG_BLOCK is not enabled by defining
> a wrapper called ima_part_pack_uuid().  The wrapper returns
> -EINVAL, when CONFIG_BLOCK is not defined.
> 
> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration
> of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> 
> Changelog v0:
> - fix UUID scripts/Lindent msgs
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Except for the scripts/checkpatch.pl warnings for this patch, it looks 
better and fixes the build error.  The build breakage has now made it to 
Linus' tree, so this will hopefully be pushed to him before rc1.
