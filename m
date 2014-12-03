Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLCCVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:21:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:48959 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaLCCVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:21:10 -0500
Message-ID: <547E738E.3060600@linux.vnet.ibm.com>
Date: Tue, 02 Dec 2014 21:21:02 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Arthur <will.c.arthur@intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120302-8236-0000-0000-0000076864D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
> +
> +#define TPM2_STARTUP_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_pcr_read_in))
> +
> +static const struct tpm_input_header tpm2_startup_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_STARTUP_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
> +};
> +
>
[...]
> +
> +#define TPM2_PCR_READ_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_pcr_read_in))
> +
> +static const struct tpm_input_header tpm2_pcrread_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> +};
> +
>
[...]
> +static const struct tpm_input_header tpm2_pcrextend_header = {
> +	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
> +	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
> +			      sizeof(struct tpm2_pcr_extend_in)),
> +	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
> +};


really just a nit: also use a #define here



> +static const struct tpm_input_header tpm2_getrandom_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
> +			      sizeof(struct tpm2_get_random_in)),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_RANDOM)
> +};
> +
also here

> +
> +#define TPM2_GET_TPM_PT_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_get_tpm_pt_in))
> +
> +static const struct tpm_input_header tpm2_get_tpm_pt_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> +};
> +


Otherwise it looks good now.

    Stefan

