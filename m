Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaDORWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:22:55 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:32847 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbaDORWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:22:53 -0400
Date: Tue, 15 Apr 2014 12:22:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Marek <mmarek@suse.cz>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
In-Reply-To: <534D6510.3070509@suse.cz>
Message-ID: <alpine.DEB.2.10.1404151221360.26992@gentwo.org>
References: <alpine.DEB.2.10.1404150940250.14106@vincent-weaver-1.um.maine.edu> <534D4A59.6080401@suse.cz> <alpine.DEB.2.10.1404151146530.26562@gentwo.org> <534D6510.3070509@suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Michal Marek wrote:

> > The problem is that the kernel build process should not write to anything
> > in the /etc/apt directory.
>
> Again: make install starts /sbin/installkernel and the rest is the job
> of this script. Which means you need to debug Debian's
> /sbin/installkernel why it suddenly wants to modify files in /etc/apt.

Why then does reverting the patch fix the issue?

Something in the patch causes install process to not divert correctly to
the install directory. It tries to go to the / directory instead.

