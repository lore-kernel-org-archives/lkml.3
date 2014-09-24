Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaIXFiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:38:25 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44619 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXFiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:38:23 -0400
Date: Tue, 23 Sep 2014 21:39:05 -0700
From: Olof Johansson <olof@lixom.net>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: khilman@linaro.org, arm@kernel.org, agross@codeaurora.org,
        galak@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc: qcom: do not disable the iface clock in probe
Message-ID: <20140924043905.GA24803@localhost>
References: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:20:54PM +0100, Srinivas Kandagatla wrote:
> since commit 31964ffebbb9 ("tty: serial: msm: Remove direct access to GSBI")'
> serial hangs if earlyprintk are enabled.
> 
> This hang is noticed only when the GSBI driver is probed and all the
> earlyprintks before gsbi probe are seen on the console.
> The reason why it hangs is because GSBI driver disables hclk in its
> probe function without realizing that the serial IP might be in use by
> a bootconsole. As gsbi driver disables the clock in probe the
> bootconsole locks up.
> 
> Turning off hclk's could be dangerous if there are system components
> like earlyprintk using the hclk.
> 
> This patch fixes the issue by delegating the clock management to
> probe and remove functions in gsbi rather than disabling the clock in probe.
> 
> More detailed problem description can be found here:
> http://www.spinics.net/lists/linux-arm-msm/msg10589.html
> 
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Hi Kevin, 
> 
> Am resending this patch with reference to the problem and adding more
> details to the log.
> 
> Could you pick this fix for the next rc, as this fixes a serial console
> hang with earlyprintk on SOCs like APQ8064.
> 
> Changes since v1:
> 	- added more info in the change log as requested by Kumar and Kevin.

Applied to fixes.


-Olof
