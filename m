Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbbAVS3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:29:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44692 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAVS3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:29:49 -0500
Date: Thu, 22 Jan 2015 10:29:47 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: qcom: Fix SCM interface for big-endian kernels
Message-ID: <20150122182947.GK27202@codeaurora.org>
References: <1421868075-20471-1-git-send-email-sboyd@codeaurora.org>
 <EF8384DD-D1D4-40F8-BCD7-D6516E923120@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF8384DD-D1D4-40F8-BCD7-D6516E923120@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Kumar Gala wrote:
> 
> On Jan 21, 2015, at 1:21 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > The secure environment only runs in little-endian mode, so any
> > buffers shared with the secure environment should have their
> > contents converted to little-endian. We also mark such elements
> > with __le32 to allow sparse to catch such problems.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> > 
> > Changes since v1:
> > * Rebased onto Kumar's qcom/soc branch
> > 
> > drivers/soc/qcom/scm-boot.c |  8 ++++----
> > drivers/soc/qcom/scm.c      | 30 ++++++++++++++++--------------
> > 2 files changed, 20 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/soc/qcom/scm-boot.c b/drivers/soc/qcom/scm-boot.c
> > index 1822b13bbc10..af16fcc8d5cb 100644
> > --- a/drivers/soc/qcom/scm-boot.c
> > +++ b/drivers/soc/qcom/scm-boot.c
> > @@ -27,12 +27,12 @@
> > int scm_set_boot_addr(u32 addr, int flags)
> > {
> > 	struct {
> > -		unsigned int flags;
> > -		phys_addr_t  addr;
> > +		__le32 flags;
> > +		__le32 addr;
> 
> How does this work?  How can we go from phys_addr_t back to __le32 on LPAE or 64-bit systems?
> 

I guess I missed updating this in the patch titled "Clarify boot
interface". In that patch we should have updated addr to be a u32
(or __le32 as is done here). From what I can tell by looking at
the codeaurora tree this is still 32 bits wide even on 64-bit
platforms.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
