Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaJ0S7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44855 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaJ0S71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:59:27 -0400
Date: Mon, 27 Oct 2014 18:59:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v3.18-rc2] staging: android: logger: Fix log corruption
 regression
Message-ID: <20141027185922.GX7996@ZenIV.linux.org.uk>
References: <1414435903-20002-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414435903-20002-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 06:51:43PM +0000, Daniel Thompson wrote:
> Since commit cd678fce4280 ("switch logger to ->write_iter()"), any
> attempt to write to the log results in the log data being written over
> its own metadata, thus rendering the log unreadable.
> 
> The problem was first detected when I ran an Android userspace on the
> v3.18-rc1 kernel. However the issue can also be observed with a
> non-Android userspace by using echo/cat to write to/from /dev/log_main .
> 
> This patch resolves the problem by using a temporary to track the status
> of not-yet-committed writes to the log buffer.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Applied
