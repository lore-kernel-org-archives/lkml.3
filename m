Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbaDXOzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:55:51 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50484 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaDXOzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:55:49 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 24 Apr 2014 07:55:35 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        eparis@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org,
        kyungsik.lee@lge.com, jslaby@suse.cz, dwight.engen@oracle.com,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE
 documentation
Message-ID: <20140424145535.GA2969@jtriplet-mobl1>
References: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:07:33PM +0200, Michael Opdenacker wrote:
> This patch proposes to warn users about the negative performance
> impact of CC_OPTIMIZE_FOR_SIZE (compiling with -Os instead of -O2).
> For the moment, we are just advising users not to select this option,
> but extra details would be useful.
> 
> I made some experiments with this option. All of them yielded
> degraded overall boot time. The kernel is smaller and hence is copied
> and started earlier, but the benefits are quickly offset by the
> slower kernel code. Even the total boot time is usually worse
> than with a regular kernel.
> 
> Here are my latest results, on Atmel SAMA5D3 Xplained (ARM),
> Linux 3.10, gzip compressed kernel:
> 
> Timestamp		O2		Os		Diff
> Starting kernel 	4.307 s 	5.593 s 	-94 ms
> Starting init		4.213 s 	5.549 s 	-44 ms
> Login prompt		21.085 s	22.900 s 	+1.815 s 

Did you get the times in the upper two rows transposed row/column?  Based
on the diffs, I'd guess 4.213s goes in Os "Starting kernel", and 5.593s
goes in O2 "Starting init".

- Josh Triplett
