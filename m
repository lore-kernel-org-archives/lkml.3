Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaJ3PVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:21:10 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46384 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760433AbaJ3PVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:21:08 -0400
Message-ID: <54525761.8070800@gmail.com>
Date: Thu, 30 Oct 2014 10:21:05 -0500
From: Don Brace <brace77070@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com,
        linux-scsi@vger.kernel.org, don.brace@pmcs.com, hch@infradead.org
Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 10:15 AM, Fabian Frederick wrote:
> Fix -Wunused-but-set-variable warning
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   drivers/scsi/hpsa.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index cef5d49..34330e1 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6619,11 +6619,11 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
>
>   static void hpsa_irq_affinity_hints(struct ctlr_info *h)
>   {
> -	int i, cpu, rc;
> +	int i, cpu;
>
>   	cpu = cpumask_first(cpu_online_mask);
>   	for (i = 0; i < h->msix_vector; i++) {
> -		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
> +		irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
>   		cpu = cpumask_next(cpu, cpu_online_mask);
>   	}
>   }
>

I can add this patch to my current set of patches for 3.19 or ack this 
now, What would you prefer?

---
Don Brace
don.brace@pmcs.com
