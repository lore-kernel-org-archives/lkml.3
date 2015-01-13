Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbbAMG3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:29:50 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49468 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAMG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:29:47 -0500
Message-ID: <54B4BB4A.9040901@linaro.org>
Date: Tue, 13 Jan 2015 14:29:30 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Suman Tripathi <stripathi@apm.com>
CC: Feng Kan <fkan@apm.com>, patches <patches@apm.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Salter <msalter@redhat.com>, Tejun Heo <tj@kernel.org>,
        hdegoede@redhat.com
Subject: Re: [PATCH] sata: xgene: add ACPI support for APM X-Gene SATA ports
References: <1418337070-17644-1-git-send-email-fkan@apm.com>	<CAL85gmAHLk9XCbr-1+USmOKxd5O7iCxWX0vqSRf74Brn2pzESg@mail.gmail.com>	<54AE36AF.3070603@linaro.org>	<CAL85gmDbZgM48C5UFgOgLiQhDU6sCmF59O_oaN8thYoYP+DFRA@mail.gmail.com>	<54AEC6D5.1050806@linaro.org> <CAOHikRA_CVoao-nBcjb=v-j3oR+s6R6cxZBkvrTxNhF_8UD=5Q@mail.gmail.com>
In-Reply-To: <CAOHikRA_CVoao-nBcjb=v-j3oR+s6R6cxZBkvrTxNhF_8UD=5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月13日 05:07, Suman Tripathi wrote:
> Hi,
>
> Tested-by: Suman Tripathi <stripathi@apm.com>
>
> On Thu, Jan 8, 2015 at 11:35 PM, Hanjun Guo <hanjun.guo@linaro.org
> <mailto:hanjun.guo@linaro.org>> wrote:
>
>     On 2015年01月09日 01:56, Feng Kan wrote:
>
>         On Wed, Jan 7, 2015 at 11:50 PM, Hanjun Guo
>         <hanjun.guo@linaro.org <mailto:hanjun.guo@linaro.org>> wrote:
>
>             Hi Feng Kan,
>
>             I have some comments below.
>
>
>             On 2015年01月08日 01:32, Feng Kan wrote:
>
>
>                 Just want to ping this again.
>
>                 Happy new year
>
>                 On Thu, Dec 11, 2014 at 2:31 PM, Feng Kan <fkan@apm.com
>                 <mailto:fkan@apm.com>> wrote:
>
>
>                     This adds ACPI support for the APM X-Gene SATA
>                     ports. When the system
>                     boots using ACPI table, the SATA ports are able to
>                     configure using the
>                     values supplied by the ACPI table rather than the DTS.
>
>                     Signed-off-by: Feng Kan <fkan@apm.com
>                     <mailto:fkan@apm.com>>
>                     ---
>                         drivers/ata/ahci_xgene.c | 10 ++++++++++
>                         1 file changed, 10 insertions(+)
>
>                     diff --git a/drivers/ata/ahci_xgene.c
>                     b/drivers/ata/ahci_xgene.c
>                     index d0c851a..4951392 100644
>                     --- a/drivers/ata/ahci_xgene.c
>                     +++ b/drivers/ata/ahci_xgene.c
>                     @@ -22,6 +22,7 @@
>                          * NOTE: PM support is not currently available.
>                          *
>                          */
>                     +#include <linux/acpi.h>
>                         #include <linux/module.h>
>                         #include <linux/platform_device.h>
>                         #include <linux/ahci_platform.h>
>                     @@ -521,6 +522,14 @@ disable_resources:
>                                return rc;
>                         }
>
>                     +#ifdef CONFIG_ACPI
>                     +static const struct acpi_device_id
>                     xgene_ahci_acpi_match[] = {
>                     +       { "APMC0D0D", },
>
>
>
>             When I was going through the PNP and ACPI ID list in
>             http://www.uefi.org/PNP_ACPI___Registry
>             <http://www.uefi.org/PNP_ACPI_Registry>, I found that
>             there is no "APMC" for ACPI ID, I only found that there is
>             a PNP ID "APM" for Applied Memory Tech company, are
>             you using PNP ID for this one?
>
>             if not, I think you can send a request to UEFI and
>             request a new ACPI ID of "APMC" for Applied Micro, and then
>             submit the patch again.
>
>             How to send a request to register the ACPI ID, you can
>             refer to:
>             http://www.uefi.org/PNP_ACPI___Registry
>             <http://www.uefi.org/PNP_ACPI_Registry>
>
>
>         Hanjun, the documents are bit out of sync. We have received
>         approval and
>         it is present in the document link below. I can also forward the
>         approval letter
>         if it needed.
>
>         http://download.microsoft.com/__download/7/E/7/7E7662CF-CBEA-__470B-A97E-CE7CE0D98DC2/ISA%__20PNPID%20List.xlsx
>         <http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/ISA%20PNPID%20List.xlsx>
>
>
>     Sorry for missing this link, I think I should report this
>     inconsistency to ACPI spec working group and then update it
>     accordingly.

Also I had reported this issue to ASWG and some people will
check with this issue and fix it, so

Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>

Thanks
Hanjun
