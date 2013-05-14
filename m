Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3ENNT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:19:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22374 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENNT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:19:28 -0400
Date: Tue, 14 May 2013 09:19:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        chuck.anderson@oracle.com
Subject: Re: [RFC 0/2] cpu: fix leak and udev race in register_cpu()
Message-ID: <20130514131923.GF5558@phenom.dumpdata.com>
References: <20130513133128.GJ6811@phenom.dumpdata.com>
 <1368482732-25554-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368482732-25554-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:05:30AM +0200, Igor Mammedov wrote:
> Here is a crude attempt fix race the way suggested by Greg,
> probably done wrong but hopefully in the right direction.

Weird, I thought I had tried that at first but got tons of kobject
warnings and such. But I think I tried to add it to kset instead of
the one you did.

It fixes it for me so
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

and also (thought the git commit descriptions need a bit of work,
but that is expected as an RFC patch):
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 1. move "crash_notes" to static attributes to guarantee that it's
> destroyed with CPU on unregister.
> 
> 2. fixes race between hotplugged CPU and onlining it via udev, described here
> https://lkml.org/lkml/2012/4/30/193
> 
> Igor Mammedov (2):
>   cpu: fix crash_notes leak
>   cpu: make sure that cpu/online file created before KOBJ_ADD is
>     emitted
> 
>  drivers/base/cpu.c |   55 +++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 38 insertions(+), 17 deletions(-)
> 
