Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3EJREO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:04:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3EJREM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:04:12 -0400
Date: Fri, 10 May 2013 10:03:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robin Holt <holt@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to
 disable/enable CPU hotplug
Message-Id: <20130510100324.e1e066ab.akpm@linux-foundation.org>
In-Reply-To: <1651579.orCh9JNVz6@vostro.rjw.lan>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
	<1367937595-32241-2-git-send-email-holt@sgi.com>
	<20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org>
	<1651579.orCh9JNVz6@vostro.rjw.lan>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013 13:11:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> ...
>
> > cpu_hotplug_disable() doesn't get compiled unless we've defined
> > CONFIG_PM_SLEEP_SMP.  I cannot begin to imagine what the logic is
> > behind that!
> 
> I suppose it was only used by suspend/hibernate code paths when this was
> introduced.

OK, well I suspect that what I have now is simply wrong for Robin's
application.  Robin, can you please check this?  We probably want to
make the does-something version of cpu_hotplug_disable/enable available
if CONFIG_HOTPLUG_CPU.


