Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaLBXJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:09:31 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:42828 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbaLBXJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:09:29 -0500
Message-ID: <547E4624.8060206@linux.vnet.ibm.com>
Date: Tue, 02 Dec 2014 18:07:16 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v8 7/8] tpm: TPM 2.0 CRB Interface
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-8-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417559480-13757-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120223-0033-0000-0000-000002DEC3F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:


> +struct acpi_tpm2 {
> +	struct acpi_table_header hdr;
> +	u16 platform_class;
> +	u16 reserved;
> +	u64 control_area_pa;
> +	u32 start_method;
> +} __packed;
[...]
> +	}
> +
> +	if (buf->hdr.length != sizeof(struct acpi_tpm2)) {

This should be

if (buf->hdr.length < sizeof(struct acpi_tpm2)) {

since the ACPI TPM2 table may have a variable number of 'Platform 
Specific Parameters' beyond the 'Start Method Field'. What we don't want 
to have is less, but more is fine.

    Stefan

