Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKZMpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:45:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48378 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKZMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:45:22 -0500
Date: Wed, 26 Nov 2014 12:45:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Subject: Re: [PATCH] staging: lustre: fix pointer declarations
Message-ID: <20141126124516.GB29748@ZenIV.linux.org.uk>
References: <1b2734828d1cfcab4aaf7f72a2444793c1d74fd0.1416947671.git.zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b2734828d1cfcab4aaf7f72a2444793c1d74fd0.1416947671.git.zahari.doychev@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:44:21PM +0100, Zahari Doychev wrote:
> This patch fixes pointer declarations from void * to void __user * in order
> to remove some sparse warnings.

_Are_ those userland addresses, though?  Quick grep shows that in the
only caller of lnet_copy_iov2flat() we have something called ibmsg passed
as the second argument *AND* *RIGHT* *BEFORE* *THAT* *CALL* *WE* *HAVE*
        ibmsg = tx->tx_msg;
        ibmsg->ibm_u.immediate.ibim_hdr = *hdr;
Go ahead, explain how does that manage to work if ibmsg is a userland pointer.
Either you have discovered an exploitable hole (direct store to userland
address), or it's not a userland pointer, after all.

Al, sick and tired of the "remove some warnings" as the sole rationale for
patches, without even an attempt to figure out what those warnings are
about.  Magic box makes noises, magic box must be appeased...
