Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaE1C57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:57:59 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:50947 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaE1C55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:57:57 -0400
Date: Tue, 27 May 2014 20:57:53 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marta Rybczynska <rybczynska@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: hotplug: cpqphp_ctrl.c:  Fix for possible null
 pointer dereference
Message-ID: <20140528025753.GM11907@google.com>
References: <1400428977-10464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400428977-10464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 06:02:57PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied to pci/hotplug for v3.16, thanks!

> ---
>  drivers/pci/hotplug/cpqphp_ctrl.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
> index 11845b7..a319d07 100644
> --- a/drivers/pci/hotplug/cpqphp_ctrl.c
> +++ b/drivers/pci/hotplug/cpqphp_ctrl.c
> @@ -709,7 +709,8 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
>  				temp = temp->next;
>  			}
>  
> -			temp->next = max->next;
> +			if(temp)
> +				temp->next = max->next;
>  		}
>  
>  		max->next = NULL;
> -- 
> 1.7.10.4
> 
