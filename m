Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaJ1FTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:19:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaJ1FTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:19:39 -0400
Date: Mon, 27 Oct 2014 22:19:35 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] eeepc-laptop: pull out eeepc_destroy_rfkill
Message-ID: <20141028051935.GF60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
 <1414005163-3461-5-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414005163-3461-5-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:12:39PM +0200, Frans Klaver wrote:
> In eeepc_rfkill_exit, we implement the same code four times. Pull out a
> function that cleans up an rfkill object to get rid of the duplication.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index e92ea41..73e8d39 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -823,35 +823,29 @@ static char EEEPC_RFKILL_NODE_1[] = "\\_SB.PCI0.P0P5";
>  static char EEEPC_RFKILL_NODE_2[] = "\\_SB.PCI0.P0P6";
>  static char EEEPC_RFKILL_NODE_3[] = "\\_SB.PCI0.P0P7";
>  
> +static inline void eeepc_destroy_rfkill(struct rfkill **rfkill)
> +{
> +	if (!*rfkill)
> +		return;
> +	rfkill_unregister(*rfkill);
> +	rfkill_destroy(*rfkill);
> +	*rfkill = NULL;
> +}

In this case the savings is 6 lines at the cost of some legibility as double
pointers are arguably harder to read, and definitely easier to screw up ;-)

I appreciate the goal, but I'm not convinced it is worth it.

-- 
Darren Hart
Intel Open Source Technology Center
