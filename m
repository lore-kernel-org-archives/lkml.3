Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3HLL3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:29:21 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59283 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3HLL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:29:17 -0400
Message-ID: <5208C6FB.8070807@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2013 16:58:59 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, m.chehab@samsung.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mce: acpi/apei: trace: Add trace event for ghes memory
 error
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-3-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808191732.GE27974@pd.tnic>
In-Reply-To: <20130808191732.GE27974@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081211-7014-0000-0000-0000037451A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 12:47 AM, Borislav Petkov wrote:
> On Thu, Aug 08, 2013 at 11:57:50PM +0530, Naveen N. Rao wrote:
>> +TRACE_EVENT(ghes_platform_memory_event,
>> +	TP_PROTO(const struct acpi_hest_generic_status *estatus,
>> +		 const struct acpi_hest_generic_data *gdata,
>> +		 const struct cper_sec_mem_err *mem),
>> +
>> +	TP_ARGS(estatus, gdata, mem),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	u32,	estatus_block_status		)
>> +		__field(	u32,	estatus_raw_data_offset		)
>> +		__field(	u32,	estatus_raw_data_length		)
>> +		__field(	u32,	estatus_data_length		)
>> +		__field(	u32,	estatus_error_severity		)
>> +		__array(	u8,	gdata_section_type,	16	)
>> +		__field(	u32,	gdata_error_severity		)
>> +		__field(	u16,	gdata_revision			)
>> +		__field(	u8,	gdata_validation_bits		)
>> +		__field(	u8,	gdata_flags			)
>> +		__field(	u32,	gdata_error_data_length		)
>> +		__array(	u8,	gdata_fru_id,		16	)
>> +		__array(	u8,	gdata_fru_text,		20	)
>> +		__field(	u64,	mem_validation_bits		)
>> +		__field(	u64,	mem_error_status		)
>> +		__field(	u64,	mem_physical_addr		)
>> +		__field(	u64,	mem_physical_addr_mask		)
>> +		__field(	u16,	mem_node			)
>> +		__field(	u16,	mem_card			)
>> +		__field(	u16,	mem_module			)
>> +		__field(	u16,	mem_bank			)
>> +		__field(	u16,	mem_device			)
>> +		__field(	u16,	mem_row				)
>> +		__field(	u16,	mem_column			)
>> +		__field(	u16,	mem_bit_pos			)
>> +		__field(	u64,	mem_requestor_id		)
>> +		__field(	u64,	mem_responder_id		)
>> +		__field(	u64,	mem_target_id			)
>> +		__field(	u8,	mem_error_type			)
>> +	),
>
> Without looking at the rest, a trace record from this tracepoint is
> going to be 160 bytes IINM, which looks kinda fat to me. And during an
> error storm we're probably not going to be able to log them all, maybe?
> Yes, no, maybe I'm off base...
>
> In any case, are we sure we want all those fields above? Can we make
> them smaller, drop some of them from the tracepoint, etc, etc? Can we
> compute some of them in userspace with information we already have?

Good idea - I hadn't thought from that perspective. I think we can drop 
a few fields there, especially the length/offset fields and perhaps the 
section_type since we know this is a memory error. Will get back with a 
new revision.

Thanks,
Naveen

