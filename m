Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaLCC2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:28:44 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56787 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaLCC2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:28:41 -0500
Message-ID: <547E7553.2050608@linux.vnet.ibm.com>
Date: Tue, 02 Dec 2014 21:28:35 -0500
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
x-cbid: 14120302-0033-0000-0000-000001331AF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:


> +
> +/**
> + * tpm2_startup() - send startup command to the TPM chip
> + * @chip:		TPM chip to use.
> + * @startup_type	startup type. The value is either
> + *			TPM_SU_CLEAR or TPM_SU_STATE.
> + *
> + * 0 is returned when the operation is successful. If a negative number is
> + * returned it remarks a POSIX error code. If a positive number is returned
> + * it remarks a TPM error.
> + */
> +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
> +{
> +	struct tpm2_cmd cmd;
> +
> +	cmd.header.in = tpm2_startup_header;
> +
> +	cmd.params.startup_in.startup_type = startup_type;
> +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +				"attempting to start the TPM");
> +}

I suppose you need to send this command because your firmware does not 
do it ?Following TPM1.2 I guess the BIOS / UEFI should send this instead 
and sending it later would actually be wrong. Hm, I don't find from 
where you are calling this... do you need it ? Can you remove it?

    Stefan


