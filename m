Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbbAXMp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 07:45:28 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54809 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbbAXMp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 07:45:26 -0500
Message-ID: <54C393DF.3090709@mm-sol.com>
Date: Sat, 24 Jan 2015 14:45:19 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Gilad Avidov <gavidov@codeaurora.org>, sdharia@codeaurora.org,
        mlocke@codeaurora.org, linux-arm-msm@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        iivanov@mm-sol.com, galak@codeaurora.org, agross@codeaurora.org
Subject: Re: [PATCH] spmi: pmic_arb: add support for hw version 2
References: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org> <54BFF66D.4000409@codeaurora.org>
In-Reply-To: <54BFF66D.4000409@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilad,

<snip>

>>  /* Interrupt Controller */
>>  #define SPMI_PIC_OWNER_ACC_STATUS(M, N)	(0x0000 + ((32 * (M)) + (4 * (N))))
> 
> It looks like these macros would change too, but nothing has been done
> here. Interrupts haven't been tested?

Stephen is right, the irq related operations are not used in irq_chip
methods. Do you plan to add it in next version?

<snip>

>> +/**
>> + * pmic_arb_ver: version dependent functionality and values.
>> + *
>> + * @non_data_cmd:	on v1 issues an spmi non-data command.
>> + * 			on v2 no HW support, returns -EOPNOTSUPP.
>> + * @offset:		on v1 offset of per-ee channel.
>> + * 			on v2 offset of per-ee and per-ppid channel.
>> + * @fmt_cmd:		formats a GENI/SPMI command.
>> + * @owner_acc_status:	on v1 offset of PMIC_ARB_SPMI_PIC_OWNERm_ACC_STATUSn
>> + * 			on v2 offset of SPMI_PIC_OWNERm_ACC_STATUSn.
>> + * @acc_enable:		on v1 offset of PMIC_ARB_SPMI_PIC_ACC_ENABLEn
>> + * 			on v2 offset of SPMI_PIC_ACC_ENABLEn.
>> + * @irq_status:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_STATUSn
>> + * 			on v2 offset of SPMI_PIC_IRQ_STATUSn.
>> + * @irq_clear:		on v1 offset of PMIC_ARB_SPMI_PIC_IRQ_CLEARn
>> + * 			on v2 offset of SPMI_PIC_IRQ_CLEARn.
>> + * @geni_ctrl:		PMIC_ARB_GENI_CTRL offset.
>> + * @geni_status:	PMIC_ARB_GENI_STATUS offset.
>> + * @protocol_irq_status: PMIC_ARB_PROTOCOL_IRQ_STATUS offset.
>> + */

<snip>

-- 
regards,
Stan
