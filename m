Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3E0HHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:07:01 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37379 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756607Ab3E0HG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:06:59 -0400
Date: Mon, 27 May 2013 09:06:35 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, zhangyanfei@cn.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: x86: platform: mrst: pr_err() need notice that
 'sdev->modalias' may not a NUL terminated string.
Message-ID: <20130527070634.GA1494@breakpoint.cc>
References: <51A1CCCE.1020103@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A1CCCE.1020103@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 04:50:22PM +0800, Chen Gang wrote:
> 
> According to the areas which use "%16.16s" within this file, the
> 'sdev->modalias' may not always be a NUL terminated string.
> 
> So need use "%.16s" instead of "%s" in pr_err(), or may cause issue.

No. spi_match_id() expects a NULL terminated string and I would be suprised if
it would be otherwise. Therefore moorsetown or this files has to learn to NULL
terminate its strings.

> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Sebastian
