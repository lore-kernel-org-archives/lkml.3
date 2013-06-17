Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3FQHBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:01:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54480 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3FQHBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:01:16 -0400
Message-ID: <51BEB41C.2000808@linux.vnet.ibm.com>
Date: Mon, 17 Jun 2013 12:30:44 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
References: <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com> <20130614181721.11206.95341.stgit@localhost.localdomain> <20130616122030.GA12290@nazgul.tnic>
In-Reply-To: <20130616122030.GA12290@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061706-9264-0000-0000-000003F5204B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 05:50 PM, Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 11:47:21PM +0530, Naveen N. Rao wrote:
>> +static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
>> +{
>> +	int i;
>> +	struct acpi_hest_ia_corrected *cmc;
>> +	struct acpi_hest_ia_error_bank *mc_bank;
>> +
>> +	if (hest_hdr->type != ACPI_HEST_TYPE_IA32_CORRECTED_CHECK)
>> +		return 0;
>> +
>> +	if (!((struct acpi_hest_generic *)hest_hdr)->enabled)
>> +		return 0;
>> +
>> +	cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>> +	if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST))
>> +		return 0;
>> +
>> +	/*
>> +	 * We expect HEST to provide a list of MC banks that
>> +	 * report errors through firmware first mode.
>> +	 */
>> +	if (cmc->num_hardware_banks <= 0)
>> +		return 0;
>> +
>> +	pr_info("HEST: Enabling Firmware First mode for corrected errors\n");
>> +
>> +	mc_bank = (struct acpi_hest_ia_error_bank *)(cmc + 1);
>> +	for (i = 0; i < cmc->num_hardware_banks; i++, mc_bank++)
>> +		mce_disable_bank(mc_bank->bank_number);
>
> One more thing: we never trust the BIOS so mce_disable_bank() should
> sanity-check this mc_bank->bank_number against the number of the
> actually available banks on the system before disabling anything.

Agreed. Will add the check.

>
> Thanks.
>

Thanks,
Naveen

